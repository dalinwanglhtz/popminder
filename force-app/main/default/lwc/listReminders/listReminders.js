import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getPopReminders from '@salesforce/apex/PopReminderController.getPopReminders';
import deletePopReminder from '@salesforce/apex/PopReminderController.deleteReminder';

const actions = [
    {label: 'Delete', name: 'delete'}
];

const columns = [
    {label: 'Reminder Description', fieldName: 'Reminder_Description__c', editable: true},
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
        editable: true},
    {label: 'Status', fieldName: 'Status__c', editable: false},
    {
        type: 'action',
        typeAttributes: {rowActions: actions}
    }
];

export default class ListReminders extends LightningElement {
    title = 'Reminders';
    @track records = [];
    @track refreshedRecords = [];
    columns = columns;
    error;

    @wire(getPopReminders)
    reminderList(result) {
        this.refreshedRecords = result;

        if(result.data) {
            this.records = result.data;
            this.error = undefined;
        } else {
            this.error = result.error;
            this.records = [];
        }
    }

    connectedCallback() {
        getPopReminders()
        .then(result => {
            this.records = result;
        })
        .catch(err => {
            this.error = err;
        });
    }

    @api refreshComponent() {
        refreshApex(this.refreshedRecords);
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