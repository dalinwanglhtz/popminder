public class PopReminderDAOService implements PopReminderDAO {

    public Pop_User__c getPopReminderUser() {
        return [
            SELECT Id, Name, Email__c, Persona__r.Name
            FROM Pop_User__c
            WHERE Persona__c = :UserInfo.getUserId()
        ];
    }
}