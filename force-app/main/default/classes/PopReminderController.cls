public without sharing class PopReminderController {
    
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
    public static Pop_User__c getPopUser(String email, String nickName) {
        Pop_User__c pUser;
        try {
            pUser = popReminderDAO.getPopReminderUser(email, nickName);
        } catch(Exception e) {
            throw new AuraHandledException('Pop User not found. Please register');
        }
        return pUser;
    }
    
    @AuraEnabled
    public static void createPopUser(String email, String nickName) {
        Pop_User__c pUser = new Pop_User__c();
        pUser.Email__c = email;
        pUser.NickName__c = nickName;
        pUser.Persona__c = UserInfo.getUserId();
        try {
        	insert pUser;    
        } catch(Exception e) {
            if(e.getMessage().contains('DUPLICATE_VALUE')) {
                throw new AuraHandledException('User already exist with this email or nick name');
            }
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void createReminders(List<Pop_Reminder__c> reminders) {
        if(!reminders.isEmpty()) {
            checkReminderDueDate(reminders);
            updateRemindersStatus(reminders);
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
    public static void updateReminder(List<Pop_Reminder__c> reminders) {
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
    
    @AuraEnabled
    public static List<String> getPickList(String objectName, String fieldName) {
		return PopReminderUtil.getPickList(objectName, fieldName);
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Pop_Reminder__c> getPopReminders(String email, String nickName) {
        Pop_User__c pUser = getPopUser(email, nickName);
        return popReminderDAO.selectRemindersByUserId(pUser.Id);
    }
    
    private static void checkReminderDueDate(List<Pop_Reminder__c> reminders) {
        for(Pop_Reminder__c reminder: reminders) {
            if(reminder.Due_Date__c < Date.today()) {
                throw new AuraHandledException('Due date cannot occur in the past for this reminder '+reminder.Reminder_Description__c);
            }
        }
    }
    
    private static void updateRemindersStatus(List<Pop_Reminder__c> reminders) {
        for(Pop_Reminder__c reminder: reminders) {
            reminder.Status__c = 'Created';
        }
    }
    
    private class AuraException extends Exception {}
}