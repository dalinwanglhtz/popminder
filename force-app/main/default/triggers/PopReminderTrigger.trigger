trigger PopReminderTrigger on Pop_Reminder__c (after insert, after delete) {

    if(Trigger.isAfter && !Test.isRunningTest()) {
        if(Trigger.isInsert) {
            PopReminderTriggerHandler.afterInsert(Trigger.New);
        }
        if(Trigger.isDelete) {
            // select Id from CronTrigger where CronJobDetail.JobType = '7' and CronJobDetail.Name = 'Reminder 20/4/2022, 10:30 pm'
            // System.abortJob('08e5j00000D1WXIAA3');
            for(Pop_Reminder__c pReminder: Trigger.Old) {
                String jobName = 'Reminder '+pReminder.Id;
                Id jobId = [
                    SELECT Id
                    FROM CronTrigger
                    WHERE CronJobDetail.JobType = '7'
                    AND CronJobDetail.Name = :jobName
                ][0].Id;
                System.abortJob(jobId);
            }
        }
    }
}