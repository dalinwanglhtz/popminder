trigger PopReminderTrigger on Pop_Reminder__c (after insert) {

    for(Pop_Reminder__c pReminder: Trigger.New) {
        Pop_User__c pUser = [
            SELECT Id, Email__c
            FROM Pop_User__c
            WHERE Id = :pReminder.Pop_User__c
        ];
        
        ScheduleWork sw = new ScheduleWork();
        sw.setEmailToAddress(pUser.Email__c);
        sw.setEmailBody(pReminder.Reminder_Description__c);
        Datetime scheduleTime = pReminder.Due_Date__c;
        String schCronExp = scheduleTime.format('s m H d M \'?\' yyyy');
        System.schedule('Testing '+scheduleTime.format(), schCronExp, sw);
    }
}