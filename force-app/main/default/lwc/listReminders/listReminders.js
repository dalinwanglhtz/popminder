import { LightningElement } from 'lwc';
import getPopReminders from '@salesforce/apex/PopReminderController.getPopReminders';

const columns = [
    {label: 'Reminder Description', fieldName: 'Reminder_Description__c', editable: true},
    {label: 'Severity', fieldName: 'Severity__c', editable: true},
    {label: 'Due Date', fieldName: 'Due_Date__c', editable: true},
    {label: 'Status', fieldName: 'Status__c', editable: false}
];

export default class ListReminders extends LightningElement {
    records;
    columns = columns;

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
}