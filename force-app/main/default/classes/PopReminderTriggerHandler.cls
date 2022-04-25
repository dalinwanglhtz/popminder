public class PopReminderTriggerHandler {

    public static void afterInsert(List<Pop_Reminder__c> newRecords) {
        Set<Id> userIds = new Set<Id>();
        for(Pop_Reminder__c pReminder: newRecords) {
            userIds.add(pReminder.Pop_User__c);
        }
        
        Map<Id, Pop_User__c> pUserMap = new Map<Id, Pop_User__c>([
            SELECT Id, Email__c
            FROM Pop_User__c
            WHERE Id IN :userIds
        ]);
    
        for(Pop_Reminder__c pReminder: newRecords) {
			PopReminderUtil.scheduleReminder(pReminder, pUserMap);
        }
    }
    
    public static void afterDelete(List<Pop_Reminder__c> oldRecords) {
        Set<String> jobNames = new Set<String>();
        for(Pop_Reminder__c pReminder: oldRecords) {
            jobNames.add('Reminder '+pReminder.Id);
        }
        
        List<CronTrigger> cTriggers = [
            SELECT Id
            FROM CronTrigger
            WHERE CronJobDetail.JobType = '7' // 7 for Scheduled Apex
            AND CronJobDetail.Name IN :jobNames
        ];
        
        for(CronTrigger cTrigger: cTriggers) {
            System.abortJob(cTrigger.Id);
        }
    }
}