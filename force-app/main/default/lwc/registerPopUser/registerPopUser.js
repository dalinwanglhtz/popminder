import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createPopUser from '@salesforce/apex/PopReminderController.createPopUser';
import getPopUser from '@salesforce/apex/PopReminderController.getPopUser';

export default class RegisterPopUser extends LightningElement {
    title = 'Register or Login!';
    error;

    handleSubmit() {
        let inputs = this.template.querySelectorAll('lightning-input');
        let email = inputs[0].value;
        let nickName = inputs[1].value;
        
        if(!this.isEmailValid(email)) {
            alert('Please enter a valid email before enter.');
            return;
        }
        if(!email || !nickName) {
            alert('Please complete all fields before enter.');
            return;
        }

        getPopUser({email: email, nickName: nickName})
        .then(result => {
            let popUser = {email: result.Email__c, nickName: result.NickName__c};
            this.showToastMessage('Success', 'Pop user found!', 'success');
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

    isEmailValid(emailValue) {
        const emailRegex=/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return emailValue.match(emailRegex);
    }

    handleEnter(event) {
        if(event.keyCode == 13) {
            this.handleSubmit();
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