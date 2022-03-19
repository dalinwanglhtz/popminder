import { LightningElement } from 'lwc';
import createPopUser from '@salesforce/apex/PopReminderController.createPopUser';

export default class RegisterPopUser extends LightningElement {
    title = 'Register Pop User';

    handleSubmit() {
        let email = this.template.querySelector('lightning-input');
        console.log('Email: ', email.value);
        createPopUser({email: email.value})
        .then(result => {
            console.log('Success');
        })
        .catch(error => {
            console.log('Error');
        });
    }
}