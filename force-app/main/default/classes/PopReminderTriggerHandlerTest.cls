@IsTest
public class PopReminderTriggerHandlerTest {

    @IsTest
    static void testInsert() {
        Pop_User__c pUser = new Pop_User__c();
        pUser.Email__c = 'dale@test.com';
        pUser.Persona__c = UserInfo.getUserId();
        insert pUser;
        
        Pop_Reminder__c newReminder = new Pop_Reminder__c();
        newReminder.Due_Date__c = Datetime.now().addMinutes(2);
        newReminder.Severity__c = 'Low';
        newReminder.Reminder_Description__c = 'Testing reminder';
        newReminder.Pop_User__c = pUser.Id;
        
        Test.startTest();
        insert newReminder;
        Test.stopTest();
        
        List<CronTrigger> cts = [
            SELECT Id
            FROM CronTrigger
            WHERE State = 'WAITING'
            AND CronJobDetail.JobType = '7'
        ];
        
        System.assert(cts.size() > 0, 'A scheduled apex job should be triggered');
    }
    
    @IsTest
    static void testDelete() {
        Pop_User__c pUser = new Pop_User__c();
        pUser.Email__c = 'dale@test.com';
        pUser.Persona__c = UserInfo.getUserId();
        insert pUser;
        
        Pop_Reminder__c newReminder = new Pop_Reminder__c();
        newReminder.Due_Date__c = Datetime.now().addMinutes(2);
        newReminder.Severity__c = 'Low';
        newReminder.Reminder_Description__c = 'Testing reminder';
        newReminder.Pop_User__c = pUser.Id;
        insert newReminder;
        
        List<CronTrigger> cts = [
            SELECT Id
            FROM CronTrigger
            WHERE State = 'WAITING'
            AND CronJobDetail.JobType = '7'
        ];
        
        System.assert(cts.size() > 0, 'Before delete, there should be scheduled apex jobs.');
        
        Test.startTest();
        delete newReminder;
        Test.stopTest();
        
        List<CronTrigger> ctsNew = [
            SELECT Id
            FROM CronTrigger
            WHERE State = 'WAITING'
            AND CronJobDetail.JobType = '7'
        ];
        
        System.assert(ctsNew.size() == 0, 'There should be no scheduled apex jobs.');
    }
}