@IsTest
public class SchedulePopReminderTest {

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
    static void testSendNotification() {
        Pop_User__c pUser = getPopUser(1)[0];
        insert pUser;
        
        List<Pop_Reminder__c> reminders = getPopReminder(2, pUser);

		Test.startTest();
		SchedulePopReminder spr = new SchedulePopReminder();
        Datetime scheduleTime = Datetime.now().addMinutes(1);
        String schCronExp = scheduleTime.format('s m H d M \'?\' yyyy');
        String jobId = System.schedule('Testingnow', schCronExp, spr);
        Test.stopTest();
        
        CronTrigger ct = [
            SELECT Id, CronExpression, TimesTriggered, NextFireTime
            FROM CronTrigger
            WHERE Id = :jobId
        ];
        
        System.assertEquals(schCronExp, ct.CronExpression, 'Cron Expression should equal.');
        System.assertEquals(0, ct.TimesTriggered, 'The job should not have run yet.');
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