import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
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
            this.getCurrentUser();
        })
        .catch(error => {
            console.log('Error: ',error.body.message);
            this.showToastMessage('Info', error.body.message, 'info');
            this.isPopUser = false;
        });
    }

    getCurrentUser() {
        getUser()
        .then(output => {
            console.log('User Name: ', output);
            this.userName = output.Name;
        })
        .catch(err => {
            console.log('User error: ', err.message);
        });
    }

    popUserRegisterHandler() {
        this.isPopUser = true;
        this.getCurrentUser();
    }

    handleReminderCreated() {
        let cmp = this.template.querySelector('c-list-reminders');
        cmp.refreshComponent();
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