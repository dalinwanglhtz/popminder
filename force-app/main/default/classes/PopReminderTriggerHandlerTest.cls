@IsTest
public class PopReminderTriggerHandlerTest {

    @TestSetup
    static void setup() {
        Profile p = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
        ];
        
        User testUser = new User(
        	Alias='dtest',
            Email='dale@test.com',
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_us',
            ProfileId = p.Id,
            TimeZoneSidKey='Australia/Sydney',
            UserName='dtest@test.org'
        );
        insert testUser;
    }
    
    @IsTest
    static void testInsert() {
        Pop_User__c pUser = getPopUser(1)[0];
        insert pUser;
        
        Pop_Reminder__c newReminder = getPopReminder(1, pUser)[0];
        
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
        Pop_User__c pUser = getPopUser(1)[0];
        insert pUser;
        
        Pop_Reminder__c newReminder = getPopReminder(1, pUser)[0];
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
    
    private static List<Pop_User__c> getPopUser(Integer numPUsers) {
		User testUser = [
            SELECT Id
            FROM User
            WHERE UserName = 'dtest@test.org'
        ];
        
        List<Pop_User__c> pUsers = new List<Pop_User__c>();
        for(Integer i=0; i<numPUsers; i++) {
            Pop_User__c pUser = new Pop_User__c();
            pUser.Email__c = 'dale'+i+'test@testing.com';
            pUser.Persona__c = testUser.Id;
            pUsers.add(pUser);
        }
        
        return pUsers;
    }
    
    private static List<Pop_Reminder__c> getPopReminder(Integer numReminders, Pop_User__c pUser) {
        List<Pop_Reminder__c> reminders = new List<Pop_Reminder__c>();
        for(Integer i = 0; i<numReminders; i++) {
            Pop_Reminder__c pReminder = new Pop_Reminder__c();
            pReminder.Due_Date__c = Datetime.now().addMinutes(2);
            pReminder.Severity__c = 'Low';
            pReminder.Reminder_Description__c = 'Test Reminder '+i;
            pReminder.Pop_User__c = pUser.Id;
            reminders.add(pReminder);
        }
        
        return reminders;
    }
}