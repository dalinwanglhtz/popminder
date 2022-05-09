import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Todolist extends LightningElement {
    isPopUser = false;
    toAddReminder = false;
    popUser;
    userName;
    email;
    error;

    popUserRegisterHandler(event) {
        this.userName = event.detail.nickName;
        this.email = event.detail.email;
        this.isPopUser = true;
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