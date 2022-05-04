public class ProcessPopReminder implements Database.Batchable<sObject> {
	public final String query;
    
    public ProcessPopReminder(String query) {
        this.query = query;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Pop_Reminder__c> scope) {
        for(Pop_Reminder__c pReminder: scope) {
            PopReminderUtil.updateStatus(pReminder);
            PopReminderUtil.sendEmail(
                pReminder.Pop_User__r.Email__c, 
                'Reminder for action', 
                pReminder.Reminder_Description__c + ' and it is '+pReminder.Status__c+'!'
            );
        }
        update scope;
    }
    
    public void finish(Database.BatchableContext BC) {
        
    }
}