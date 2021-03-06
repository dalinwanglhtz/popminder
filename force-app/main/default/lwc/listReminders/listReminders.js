import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getPopReminders from '@salesforce/apex/PopReminderController.getPopReminders';
import deletePopReminder from '@salesforce/apex/PopReminderController.deleteReminder';
import updatePopReminder from '@salesforce/apex/PopReminderController.updateReminder';

const actions = [
    {label: 'Delete', name: 'delete'}
];

const columns = [
    {label: 'Reminder Description', fieldName: 'Reminder_Description__c', editable: true, initialWidth: 700},
    {label: 'Severity', fieldName: 'Severity__c', editable: true},
    {
        label: 'Due Date', 
        fieldName: 'Due_Date__c', 
        type: 'date', 
        typeAttributes: {
            year: 'numeric',
            month: 'long',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit'
        },
        editable: true,
        sortable: true},
    {label: 'Status', fieldName: 'Status__c', editable: false},
    {
        type: 'action',
        typeAttributes: {rowActions: actions}
    }
];

export default class ListReminders extends LightningElement {
    title = 'Reminders';
    @api email;
    @api nickName;
    @track records = [];
    @track refreshedRecords = [];
    columns = columns;
    error;
    draftValues = [];
    sortBy;
    sortDirection;

    // Pagination variables start
    page = 1;
    pageSize = 3;
    totalPage = 0;
    items = [];
    totalRecordsCount = 0;
    startingRecord = 1;
    endingRecord = 0;
    isPageChanged = false;
    // Pagination variables end

    // Search variables start
    originalRecords = [];
    searchKey = '';
    // Search variables end

    @wire(getPopReminders, {email: '$email', nickName: '$nickName'})
    reminderList(result) {
        this.refreshedRecords = result;

        if(result.data) {
            this.originalRecords = result.data;
            this.processRecords(result.data);
            this.error = undefined;
        } else {
            this.error = result.error;
            this.records = [];
        }
    }

    @api refreshComponent() {
        refreshApex(this.refreshedRecords);
    }

    // Pagination method
    processRecords(data) {
        this.items = data;
        this.totalRecordsCount = data.length;
        this.totalPage = Math.ceil(this.totalRecordsCount / this.pageSize);
        this.records = this.items.slice(0, this.pageSize);
        this.endingRecord = this.pageSize;
    }

    // Pagination method
    previousHandler() {
        this.isPageChanged = true;
        if(this.page > 1) {
            this.page -= 1;
            this.displayRecordPerPage(this.page);
        }
    }

    // Pagination mehod
    nextHandler() {
        this.isPageChanged = true;
        if(this.page < this.totalPage && this.page !== this.totalPage) {
            this.page += 1;
            this.displayRecordPerPage(this.page);
        }
    }

    // Pagination method
    displayRecordPerPage(page) {
        this.startingRecord = ((page - 1) * this.pageSize);
        this.endingRecord = this.pageSize * page;
        this.endingRecord = (this.endingRecord > this.totalRecordsCount) ? this.totalRecordsCount : this.endingRecord;
        this.records = this.items.slice(this.startingRecord, this.endingRecord);
    }

    // Search method
    handleKeyChange(event) {
        this.searchKey = event.target.value;
        let sKey = this.searchKey.toLowerCase();
        let data = [];
        if(sKey == '') {
            data = [...this.originalRecords];
        } else {            
            this.items.forEach((item) => {
                if(item != undefined && item.Reminder_Description__c.toLowerCase().includes(sKey)) {
                    data.push(item);
                }
            });
        }
        this.processRecords(data);
    }

    handleRowAction(event) {
        //const actionName = event.detail.action.name;
        const row = event.detail.row;
        deletePopReminder({recordId: row.Id})
        .then(result => {
            this.showToastMessage('Success', 'Reminder Deleted!', 'success');
            refreshApex(this.refreshedRecords);
        })
        .catch(err => {
            this.error = err;
        });
    }

    handleShowHide() {
        this.dispatchEvent(
            new CustomEvent('triggershowhide')
        );
    }

    async handleSave(event) {
        const updatedFields = event.detail.draftValues;

        try {
            await updatePopReminder({reminders: updatedFields});
            this.showToastMessage('Success', 'Reminder(s) updated successfully', 'success');

            refreshApex(this.refreshedRecords)
            .then(() => {
                this.draftValues = [];
            });
        } catch(error) {
            this.showToastMessage('Error', 'Update reminder(s) failed. Please make sure all fields are entered properly', 'error');
        }
    }

    handleSort(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortRecords(this.sortBy, this.sortDirection);
    }

    sortRecords(fieldName, direction) {
        let parseData = JSON.parse(JSON.stringify(this.records));
        let keyValue = (a) => {
            return a[fieldName];
        }

        let isReverse = direction == 'asc' ? 1 : -1;

        parseData.sort((x,y) => {
            x = keyValue(x) ? keyValue(x) : '';
            y = keyValue(y) ? keyValue(y) : '';
            return isReverse * ((x>y) - (x<y));
        });
        this.records = parseData;
    }

    showToastMessage(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }
}