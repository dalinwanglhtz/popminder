import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPopReminders from '@salesforce/apex/PopReminderController.getPopReminders';
import getUser from '@salesforce/apex/PopReminderController.getUser';
import getPopUser from '@salesforce/apex/PopReminderController.getPopUser';

export default class Todolist extends LightningElement {
    isPopUser;
    popUser;
    userName;

    connectedCallback() {
        getPopUser()
        .then(result => {
            console.log('Success: ', result.Persona__c);
            this.isPopUser = true;
            getUser({userId: result.Persona__c})
            .then(output => {
                console.log('User Name: ', output);
                this.userName = output.Name;
            })
            .catch(err => {
                console.log('User error: ', err.message);
            });
        })
        .catch(error => {
            console.log('Error: ',error.message);
            this.isPopUser = false;
        });
    }
}