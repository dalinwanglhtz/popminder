public class ProcessPopReminder implements Database.Batchable<sObject> {
	public final String query;
    
    public ProcessPopReminder(String query) {
        this.query = query;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Pop_Reminder__c> scope) {
        Map<String, String> emailsToSend = new Map<String, String>();
        for(Pop_Reminder__c pReminder: scope) {
            PopReminderUtil.updateStatus(pReminder);
            String currentDescription = emailsToSend.get(pReminder.Pop_User__r.Email__c);
            String emailBody = emailsToSend.get(pReminder.Pop_User__r.Email__c) != null ? 
                currentDescription + pReminder.Reminder_Description__c + ' and it is '+pReminder.Status__c+'!'+'<br/>' : 
            	pReminder.Reminder_Description__c + ' and it is '+pReminder.Status__c+'!'+'<br/>';
            emailsToSend.put(pReminder.Pop_User__r.Email__c, emailBody);
        }
        
        for(String emailKey: emailsToSend.keySet()) {
            PopReminderUtil.sendEmail(
                emailKey, 
                'Reminder for action', 
                emailsToSend.get(emailKey)
            );
        }
        
        update scope;
    }
    
    public void finish(Database.BatchableContext BC) {
        
    }
}