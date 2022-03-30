import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getUser from '@salesforce/apex/PopReminderController.getUser';
import getPopUser from '@salesforce/apex/PopReminderController.getPopUser';

export default class Todolist extends LightningElement {
    isPopUser;
    toAddReminder = false;
    popUser;
    userName;
    error;

    connectedCallback() {
        getPopUser()
        .then(result => {
            this.isPopUser = true;
            this.getCurrentUser();
        })
        .catch(error => {
            this.showToastMessage('Info', error.body.message, 'info');
            this.isPopUser = false;
        });
    }

    getCurrentUser() {
        getUser()
        .then(output => {
            this.userName = output.Name;
        })
        .catch(err => {
            this.error = err;
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

    handleShowHide() {
        this.toAddReminder = !this.toAddReminder;
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