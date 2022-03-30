import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createPopUser from '@salesforce/apex/PopReminderController.createPopUser';
import getUser from '@salesforce/apex/PopReminderController.getUser';

export default class RegisterPopUser extends LightningElement {
    title = 'Register Pop User';
    emailValue;
    error;

    connectedCallback() {
        getUser()
        .then(result => {
            this.emailValue = result.Email;
        })
        .catch(err => {
            this.error = err;
        });
    }

    handleSubmit() {
        let email = this.template.querySelector('lightning-input');
        createPopUser({email: email.value})
        .then(result => {
            this.showToastMessage('Success', 'Pop user registered successfully!', 'success');
            this.dispatchEvent(
                new CustomEvent('popuserregistered')
            );
        })
        .catch(error => {
            this.showToastMessage('Error', 'Pop user failed to register: '+error.body.message, 'error');
        });
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