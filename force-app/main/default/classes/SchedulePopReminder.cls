// SchedulePopReminder sw = new SchedulePopReminder();
// run every 30 min
// String sch = '0 30 * * * ? *';
// System.schedule('Testing11', sch, sw);
global class SchedulePopReminder implements Schedulable {

    global void execute(SchedulableContext sc) {
        // Get list of reminders that are due today, tmr and the day after. Send notification and update status
        List<Pop_Reminder__c> reminders = [
            SELECT Id, Status__c, Due_Date__c, Reminder_Description__c, Pop_User__r.Email__c
            FROM Pop_Reminder__c
            WHERE Due_Date__c <= :Datetime.now().addDays(2)
        ];
        System.debug('Run with '+reminders.size()+' reminders');
        for(Pop_Reminder__c pReminder: reminders) {
            if(pReminder.Due_Date__c <= Datetime.now()) {
            	pReminder.Status__c = 'Due';    
            } else if(pReminder.Due_Date__c <= Datetime.now().addDays(1) && pReminder.Due_Date__c > Datetime.now()) {
                pReminder.Status__c = 'Almost Due';
            } else if(pReminder.Due_Date__c <= Datetime.now().addDays(2) && pReminder.Due_Date__c > Datetime.now().addDays(1)) {
                pReminder.Status__c = 'Counting Down';
            }
            PopReminderUtil.sendEmail(pReminder.Pop_User__r.Email__c, 'Reminder for action', pReminder.Reminder_Description__c);
        }
        update reminders;
    }
}