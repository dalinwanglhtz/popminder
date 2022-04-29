// SchedulePopReminder sw = new SchedulePopReminder();
// run at 2022-4-15 4:50pm
// String sch = '0 33 21 29 4 ? 2022';
// System.schedule('Testing4', sch, sw);
global class SchedulePopReminder implements Schedulable {

    global void execute(SchedulableContext sc) {
        // Get list of reminders that are due today. Send notification and update status to Due
        List<Pop_Reminder__c> reminders = [
            SELECT Id, Status__c, Due_Date__c, Reminder_Description__c, Pop_User__r.Email__c
            FROM Pop_Reminder__c
            WHERE Due_Date__c <= :Datetime.now()
        ];
        for(Pop_Reminder__c pReminder: reminders) {
            pReminder.Status__c = 'Due';
            PopReminderUtil.sendEmail(pReminder.Pop_User__r.Email__c, 'Reminder for action', pReminder.Reminder_Description__c);
        }
        update reminders;
        
        // Get list of reminders that are due tmr. Send notification and update status to Almost Due

        // Get list of reminders that are due the day after. Send notification and update status to Counting Down
        
    }
}