trigger PopReminderTrigger on Pop_Reminder__c (after insert) {
    Set<Id> userIds = new Set<Id>();
    for(Pop_Reminder__c pReminder: Trigger.New) {
        userIds.add(pReminder.Pop_User__c);
    }
    
    Map<Id, Pop_User__c> pUserMap = new Map<Id, Pop_User__c>([
        SELECT Id, Email__c
        FROM Pop_User__c
        WHERE Id IN :userIds
    ]);

    for(Pop_Reminder__c pReminder: Trigger.New) {
        Pop_User__c pUser = pUserMap.get(pReminder.Pop_User__c);
        ScheduleWork sw = new ScheduleWork();
        sw.setEmailToAddress(pUser.Email__c);
        sw.setEmailSubject('Reminder for action!!');
        sw.setEmailBody(pReminder.Reminder_Description__c);
        Datetime scheduleTime = pReminder.Due_Date__c;
        String schCronExp = scheduleTime.format('s m H d M \'?\' yyyy');
        System.schedule('Reminder '+scheduleTime.format(), schCronExp, sw);
    }
}