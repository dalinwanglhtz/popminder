public class PopReminderDAOService implements PopReminderDAO {

    public Pop_User__c getPopReminderUser(String email, String nickName) {
        return [
            SELECT Id, Name, Email__c, Persona__r.Name, NickName__c
            FROM Pop_User__c
            WHERE Email__c = :email AND NickName__c = :nickName
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
            ORDER BY Due_Date__c ASC
        ];
    }
}