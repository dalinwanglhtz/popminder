import { LightningElement, track, api } from 'lwc';
import createReminders from '@salesforce/apex/PopReminderController.createReminders';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [
    {"label":"Reminder", "apiName":"Reminder_Description__c", "fieldType":"text", "objectName":"Pop_Reminder__c"},
    {"label":"Severity", "apiName":"Severity__c", "fieldType":"picklist", "objectName":"Pop_Reminder__c"},
    {"label":"Due Date", "apiName":"Due_Date__c", "fieldType":"datetime", "objectName":"Pop_Reminder__c"}
]
export default class AddReminder extends LightningElement {
    @track records;
    @api recordJson;
    @track columns=columns;

    submit(event) {
        var table = this.template.querySelector('c-dynamic-table');
        if(table != undefined) {
            this.records = table.retrieveRecords();

            console.log(JSON.stringify(this.records));
            createReminders({ reminders: this.records})
            .then(result => { 
                this.message = result;
                this.error = undefined;
                this.showToastMessage('Success', 'Reminders created', 'success');
                this.dispatchEvent(
                    new CustomEvent('remindercreated')
                );
                table.clearRows();
            })
            .catch(err => {
                this.message = undefined;
                this.error = err;
                this.showToastMessage('Error creating records', err.body.message, 'error');
            })
        }
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