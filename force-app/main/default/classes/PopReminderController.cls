public class PopReminderController {

    @auraenabled(cacheable=true)
    public static List<Pop_Reminder__c> getPopReminders(String userId) {
        return [
            SELECT Id, Name, Reminder_Description__c, Due_Date__c, Severity__c
            FROM Pop_Reminder__c
        ];
    }
}