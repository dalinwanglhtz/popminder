trigger PopReminderTrigger on Pop_Reminder__c (after insert) {

    if(Trigger.isAfter && !Test.isRunningTest()) {
        if(Trigger.isInsert){
            PopReminderTriggerHandler.afterInsert(Trigger.New);
        }
    }
}