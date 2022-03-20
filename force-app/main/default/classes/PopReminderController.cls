public class PopReminderController {

    @auraenabled
    public static User getUser(Id userId) {
        User user = new User();
        try {
            user = [
                SELECT Id, Name
                FROM User
                WHERE Id = :userId
            ];
        } catch (Exception e) {
            throw new AuraHandledException('User not found. '+e.getMessage());
        }
        
        return user;
    }
    
    @auraenabled
    public static Pop_User__c getPopUser() {
        Pop_User__c pUser = new Pop_User__c();
        try {
            pUser = [
                SELECT Id, Name, Email__c, Persona__r.Name
                FROM Pop_User__c
                WHERE Persona__c = :UserInfo.getUserId()
        	];
        } catch(Exception e) {
            throw new AuraHandledException('Pop User not found. '+e.getMessage());
        }
        return pUser;
    }
    
    @auraenabled
    public static void createPopUser(String email) {
        Pop_User__c pUser = new Pop_User__c();
        pUser.Email__c = email;
        pUser.Persona__c = UserInfo.getUserId();
        insert pUser;
    }
    
    @auraenabled
    public static void createReminders(List<Pop_Reminder__c> reminders) {
        if(!reminders.isEmpty()) {
            insert reminders;
        }
    }
    
    @auraenabled(cacheable=true)
    public static List<String> getPickList(String objectName, String fieldName) {
        List<String> values = new List<String>();
        List<Schema.DescribeSObjectResult> results = Schema.describeSObjects(new List<String> {objectName});
        
        for(Schema.DescribeSObjectResult res: results) {
            for(Schema.PicklistEntry entry: res.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) {
                if(entry.isActive()) {
                    values.add(entry.getValue());
                }
            }
        }
        return values;
    }
    
    @auraenabled(cacheable=true)
    public static List<Pop_Reminder__c> getPopReminders(String userId) {
        return [
            SELECT Id, Name, Reminder_Description__c, Due_Date__c, Severity__c, Status__c
            FROM Pop_Reminder__c
            WHERE Pop_User__c = :userId
        ];
    }
    
    private class AuraException extends Exception {}
}