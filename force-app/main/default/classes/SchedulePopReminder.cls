// SchedulePopReminder sw = new SchedulePopReminder();
// run 7 am every day
// String sch = '0 0 07 * * ? *';
// System.schedule('Testing11', sch, sw);
global class SchedulePopReminder implements Schedulable {

    global void execute(SchedulableContext sc) {
        // Get list of reminders that are due today, tmr and the day after. Send notification and update status
        String formatedDt = Datetime.now().addDays(2).format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        String selectClause = 'SELECT Id, Status__c, Due_Date__c, Reminder_Description__c, Pop_User__r.Email__c';
        String fromClause = 'FROM Pop_Reminder__c';
        String whereClause = 'WHERE Due_Date__c <= '+formatedDt;
        String orderByClause = 'ORDER BY Due_Date__c ASC';
        String query = selectClause + ' ' + fromClause + ' ' + whereClause + ' ' + orderByClause;
        Id batchInstanceId = Database.executeBatch(new ProcessPopReminder(query), PopReminderConstant.PROCESS_REMINDER_BATCH_SIZE);
    }
}