public class PopReminderController {
    
    public static PopReminderDAO popReminderDAO {
        get {
            if(popReminderDAO == null) {
                popReminderDAO = new PopReminderDAOService();
            }
            return popReminderDAO;
        }
        set {
            popReminderDAO = value;
        }
    } 

    @AuraEnabled
    public static User getUser() {
        User user = new User();
        try {
            user = popReminderDAO.getCurrentUser();
        } catch (Exception e) {
            throw new AuraHandledException('User not found. ');
        }
        
        return user;
    }
    
    @AuraEnabled
    public static Pop_User__c getPopUser() {
        Pop_User__c pUser = new Pop_User__c();
        try {
            pUser = popReminderDAO.getPopReminderUser();
        } catch(Exception e) {
            throw new AuraHandledException('Pop User not found. Please register');
        }
        return pUser;
    }
    
    @AuraEnabled
    public static void createPopUser(String email) {
        Pop_User__c pUser = new Pop_User__c();
        pUser.Email__c = email;
        pUser.Persona__c = UserInfo.getUserId();
        insert pUser;
    }
    
    @AuraEnabled
    public static void createReminders(List<Pop_Reminder__c> reminders) {
        Pop_User__c pUser = getPopUser();
        if(!reminders.isEmpty()) {
            for(Pop_Reminder__c reminder: reminders) {
                if(reminder.Due_Date__c < Date.today()) {
                    throw new AuraHandledException('Due date cannot occur in the past for this reminder '+reminder.Reminder_Description__c);
                }
                reminder.Status__c = 'Created';
            	reminder.Pop_User__c = pUser.Id;
        	}
            try{
            	insert reminders;    
            } catch (Exception e) {
                if(e.getMessage().contains('REQUIRED_FIELD_MISSING')) {
                	throw new AuraHandledException('Please complete all fields before submit.');    
                }
                throw new AuraHandledException(e.getMessage());
            }
        }
    }
    
    @AuraEnabled
    public static void updateReminder(Object data) {
        List<Pop_Reminder__c> reminders = (List<Pop_Reminder__c>) JSON.deserialize(
            JSON.serialize(data), 
            List<Pop_Reminder__c>.class);
        try {
            update reminders;
        } catch(Exception e) {
            throw new AuraHandledException('Failed to update reminder(s). Due to: '+e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void deleteReminder(String recordId) {
        Pop_Reminder__c pReminder = popReminderDAO.selectReminderById(recordId);
        delete pReminder;
    }
    
    @AuraEnabled(cacheable=true)
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
    
    @AuraEnabled(cacheable=true)
    public static List<Pop_Reminder__c> getPopReminders(String userId) {
        Pop_User__c pUser = getPopUser();
        return [
            SELECT Id, Name, Reminder_Description__c, Due_Date__c, Severity__c, Status__c
            FROM Pop_Reminder__c
            WHERE Pop_User__c = :pUser.Id
            ORDER BY Due_Date__c DESC
        ];
    }
    
    private class AuraException extends Exception {}
}