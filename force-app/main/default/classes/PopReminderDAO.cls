public interface PopReminderDAO {

    Pop_User__c getPopReminderUser();
    User getCurrentUser();
    Pop_Reminder__c selectReminderById(String recordId);
    List<Pop_Reminder__c> selectRemindersByUserId(String userId);
}