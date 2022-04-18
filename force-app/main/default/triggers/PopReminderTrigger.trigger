trigger PopReminderTrigger on Pop_Reminder__c (after insert) {

    for(Pop_Reminder__c pReminder: Trigger.New) {
        Pop_User__c pUser = [
            SELECT Id, Email__c
            FROM Pop_User__c
            WHERE Id = :pReminder.Pop_User__c
        ];
        System.debug('Email: '+pUser.Email__c);
        System.debug('Date to complete: '+pReminder.Due_Date__c);
        
        ScheduleWork sw = new ScheduleWork();
        // run at 2022-4-15 4:50pm
        //String sch = '0 07 16 18 4 ? 2022';
        Datetime scheduleTime = pReminder.Due_Date__c;
        String schCronExp = scheduleTime.format('s m H d M \'?\' yyyy');
        System.schedule('Testing '+scheduleTime.format(), schCronExp, sw);
    }
}