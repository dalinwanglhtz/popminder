// SchedulePopReminder sw = new SchedulePopReminder();
// run 7 am every day
// String sch = '0 0 07 * * ? *';
// System.schedule('Testing11', sch, sw);
global class SchedulePopReminder implements Schedulable {

    global void execute(SchedulableContext sc) {
        // Get list of reminders that are due today, tmr and the day after. Send notification and update status
        String untilDt = Datetime.now().addDays(PopReminderConstant.DAYS_UNTIL_IN_DUE_REMINDERS).format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        String fromDt = Datetime.now().addDays(PopReminderConstant.DAYS_FROM_IN_DUE_REMINDERS).format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        String selectClause = 'SELECT Id, Status__c, Severity__c, Due_Date__c, Reminder_Description__c, Pop_User__r.Email__c';
        String fromClause = 'FROM Pop_Reminder__c';
        String whereClause = 'WHERE Due_Date__c <= '+untilDt;
        String andWhereClause = 'AND Due_Date__c > '+fromDt;
        String orderByClause = 'ORDER BY Due_Date__c ASC';
        String query = selectClause + ' ' + fromClause + ' ' + whereClause + ' ' + andWhereClause + ' ' + orderByClause;
        Id batchInstanceId = Database.executeBatch(new ProcessPopReminder(query), PopReminderConstant.PROCESS_REMINDER_BATCH_SIZE);
    }
}