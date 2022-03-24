import { LightningElement, api, track, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getPopReminders from '@salesforce/apex/PopReminderController.getPopReminders';

const columns = [
    {label: 'Reminder Description', fieldName: 'Reminder_Description__c', editable: true},
    {label: 'Severity', fieldName: 'Severity__c', editable: true},
    {label: 'Due Date', fieldName: 'Due_Date__c', editable: true},
    {label: 'Status', fieldName: 'Status__c', editable: false}
];

export default class ListReminders extends LightningElement {
    title = 'Reminders';
    @track records = [];
    @track refreshedRecords = [];
    columns = columns;

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
            console.log('Get Pop Reminder: ', result);
            this.records = result;
        })
        .catch(err => {
            console.log('Error getting pop reminder: ', err.body.message);
        });
    }

    @api refreshComponent() {
        refreshApex(this.refreshedRecords);
    }
}