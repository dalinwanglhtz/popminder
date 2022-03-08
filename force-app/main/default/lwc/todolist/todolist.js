import { LightningElement, track, api } from 'lwc';
import createReminders from '@salesforce/apex/PopReminderController.createReminders';
import getPopReminders from '@salesforce/apex/PopReminderController.getPopReminders';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [
    {"label":"Reminder", "apiName":"Reminder_Description__c", "fieldType":"text", "objectName":"Pop_Reminder__c"},
    {"label":"Severity", "apiName":"Severity__c", "fieldType":"picklist", "objectName":"Pop_Reminder__c"}
]

export default class Todolist extends LightningElement {
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
                if(this.message != undefined) {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Sucess',
                            message: 'Reminders created',
                            variant: 'success'
                        })
                    );
                }

                console.log(JSON.stringify(result));
                console.log("result", this.message);
            })
            .catch(error => {
                this.message = undefined;
                this.error = error;

                console.log('Error: ', JSON.stringify(this.error));
                this.dispatchEvent(
                    new ShowToastEvent({ 
                        title: 'Error creating records',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            })
        }
    }
}