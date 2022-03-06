import { LightningElement } from 'lwc';
import getPopReminders from '@salesforce/apex/PopReminderController.getPopReminders';
import { updateRecord } from 'lightning/uiRecordApi';

import POP_REMINDER_FIELD from '@salesforce/schema/Pop_Reminder__c.Reminder_Description__c';
import POP_DUE_DATE_FIELD from '@salesforce/schema/Pop_Reminder__c.Due_Date__c';
import POP_SEVERITY_FIELD from '@salesforce/schema/Pop_Reminder__c.Severity__c';


export default class Todolist extends LightningElement {}