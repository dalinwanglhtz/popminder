import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Todolist extends LightningElement {
    isPopUser = false;
    toAddReminder = false;
    popUser;
    userName;
    displayName;
    email;
    error;

    popUserRegisterHandler(event) {
        this.userName = event.detail.nickName;
        this.displayName = this.userName.substring(0,1).toUpperCase() + this.userName.substring(1, this.userName.length);
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

    handleLogout() {
        location.reload();
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