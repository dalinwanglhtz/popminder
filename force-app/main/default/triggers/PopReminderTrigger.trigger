trigger PopReminderTrigger on Pop_Reminder__c (after insert, after delete) {

    if(Trigger.isAfter && !Test.isRunningTest()) {
        if(Trigger.isInsert) {
            PopReminderTriggerHandler.afterInsert(Trigger.New);
        }
        if(Trigger.isDelete) {
			PopReminderTriggerHandler.afterDelete(Trigger.Old);
        }
    }
}