public interface PopReminderDAO {

    Pop_User__c getPopReminderUser(String email, String nickName);
    Pop_Reminder__c selectReminderById(String recordId);
    List<Pop_Reminder__c> selectRemindersByUserId(String userId);
}