public class PopReminderDAOService implements PopReminderDAO {

    public Pop_User__c getPopReminderUser() {
        return [
            SELECT Id, Name, Email__c, Persona__r.Name
            FROM Pop_User__c
            WHERE Persona__c = :UserInfo.getUserId()
        ];
    }
    
    public User getCurrentUser() {
        return [
            SELECT Id, Name, Email
            FROM User
            WHERE Id = :UserInfo.getUserId()
        ];
    }
    
    public Pop_Reminder__c selectReminderById(String recordId) {
        return [
            SELECT Id, Name
            FROM Pop_Reminder__c
            WHERE Id = :recordId
        ];
    }
    
    public List<Pop_Reminder__c> selectRemindersByUserId(String userId) {
        return [
            SELECT Id, Name, Reminder_Description__c, Due_Date__c, Severity__c, Status__c
            FROM Pop_Reminder__c
            WHERE Pop_User__c = :userId
            ORDER BY Due_Date__c DESC
        ];
    }
}