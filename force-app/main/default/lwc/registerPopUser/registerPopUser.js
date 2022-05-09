import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createPopUser from '@salesforce/apex/PopReminderController.createPopUser';
import getUser from '@salesforce/apex/PopReminderController.getUser';
import getPopUser from '@salesforce/apex/PopReminderController.getPopUser';

export default class RegisterPopUser extends LightningElement {
    title = 'Register Pop User';
    emailValue;
    nickNameValue;
    error;

    handleSubmit() {
        let inputs = this.template.querySelectorAll('lightning-input');
        let email = inputs[0].value;
        let nickName = inputs[1].value;

        getPopUser({email: email, nickName: nickName})
        .then(result => {
            let popUser = {email: result.Email__c, nickName: result.NickName__c};
            this.showToastMessage('Success', 'Pop user registered successfully!', 'success');
            this.dispatchEvent(
                new CustomEvent('popuserfound', {detail: popUser})
            );
        })
        .catch(error => {
            this.showToastMessage('Info', error.body.message, 'info');
            createPopUser({email: email, nickName: nickName})
            .then(result => {
                this.showToastMessage('Success', 'Pop user registered successfully!', 'success');
                let popUser = {email: email, nickName: nickName};
                this.dispatchEvent(
                    new CustomEvent('popuserregistered', {detail: popUser})
                );
            })
            .catch(error => {
                this.showToastMessage('Error', 'Pop user failed to register: '+error.body.message, 'error');
            });
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