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
        String rowStyle = 'padding:5px;border:1px solid #000';
        for(Pop_Reminder__c pReminder: scope) {
            PopReminderUtil.updateStatus(pReminder);
            String currentDescription = emailsToSend.get(pReminder.Pop_User__r.Email__c);
            String emailBody = PopReminderUtil.processDescription(
                currentDescription, 
                '<td style="'+rowStyle+'">' + pReminder.Due_Date__c.format(dateFormat) + '</td>' + 
                '<td style="'+rowStyle+'">' + pReminder.Reminder_Description__c + '</td>' +
                '<td style="'+rowStyle+'"><b>' + pReminder.Status__c + '</b></td>' +
                '<td style="'+rowStyle+'"><b>' + pReminder.Severity__c + '</b></td>'
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
        
        if(!scope.isEmpty()) {
        	update scope;    
        }
    }
    
    public void finish(Database.BatchableContext BC) {
        
    }
}