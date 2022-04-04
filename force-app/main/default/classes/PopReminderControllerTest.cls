@IsTest
public class PopReminderControllerTest {
    
    @TestSetup
    static void setup() {
        Pop_User__c pUser = new Pop_User__c();
        pUser.Email__c = 'test@email.com';
        pUser.Persona__c = UserInfo.getUserId();
        insert pUser;
    }

    @IsTest
    static void testGetUser() {
        PopReminderController.popReminderDAO = new MockPopReminderDAOServiceImpl();
        
        Test.startTest();
        User testUser = PopReminderController.getUser();
        Test.stopTest();
        
        System.assertEquals(UserInfo.getUserId(), testUser.Id, 'User ID returned should be the same as current user.');
    }
    
    @IsTest
    static void testGetPopReminderUser() {
        PopReminderController.popReminderDAO = new MockPopReminderDAOServiceImpl();
        
        Test.startTest();
        Pop_User__c pUser = PopReminderController.getPopUser();
        Test.stopTest();
        
        System.assertEquals('test@email.com', pUser.Email__c, 'Pop User returned correctly');
    }
    
    @IsTest
    static void testCreatePopUser() {
        String testEmail = 'dale@email.com';
        
        Test.startTest();
        PopReminderController.createPopUser(testEmail);
        Test.stopTest();
        
        Pop_User__c pUser = [
            SELECT Id, Name, Email__c
            FROM Pop_User__c
            WHERE Email__c = :testEmail
        ];
        
        System.assert(pUser != null, 'Pop user created successfully');
    }
    
    @IsTest
    static void testCreateReminders() {
        PopReminderController.popReminderDAO = new MockPopReminderDAOServiceImpl();
        
        Pop_User__c pUser = [
            SELECT Id, Name, Email__C
            FROM Pop_User__c
            LIMIT 1
        ];
        
        List<Pop_Reminder__c> reminders = new List<Pop_Reminder__c>();
        for(Integer i=0; i<2; i++) {
            Pop_Reminder__c pReminder = new Pop_Reminder__c();
            pReminder.Reminder_Description__c = 'test '+i;
            pReminder.Severity__c = 'High';
            pReminder.Due_Date__c = Date.today();
            pReminder.Pop_User__c = pUser.Id;
            reminders.add(pReminder);
        }
        
        Test.startTest();
        PopReminderController.createReminders(reminders);
        Test.stopTest();
        
        List<Pop_Reminder__c> results = [
            SELECT ID, Reminder_Description__c
            FROM Pop_Reminder__c
        ];
        
        System.assertEquals(2, results.size(), 'Should return a list of reminders created');
    }
    
    public class MockPopReminderDAOServiceImpl extends MockPopReminderDAOService {

        public override User getCurrentUser() {
            User user = new User();
            user.Id = UserInfo.getUserId();
            return user;
        }
        
        public override Pop_User__c getPopReminderUser() {
            ID userId = TestUtility.getFakeId(Pop_User__c.SObjectType);
            Pop_User__c pUser = new Pop_User__c();
            pUser.Persona__c = UserInfo.getUserId();
            pUser.Email__c = 'test@email.com';
            pUser.Id = userId;
            return pUser;
        }
    }
}