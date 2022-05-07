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
        String dateFormat = 'yyyy-MM-dd HH:mm:ss';
        for(Pop_Reminder__c pReminder: scope) {
            PopReminderUtil.updateStatus(pReminder);
            String currentDescription = emailsToSend.get(pReminder.Pop_User__r.Email__c);
            String emailBody = PopReminderUtil.processDescription(
                currentDescription, 
                pReminder.Due_Date__c.format(dateFormat) + ' - ' + 
                pReminder.Reminder_Description__c + 
                ' - (<b>'+pReminder.Status__c+'</b>)'
            );
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