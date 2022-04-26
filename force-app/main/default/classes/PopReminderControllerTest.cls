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
    static void testGetPopReminderUserFailed() {
        Pop_User__c pUser = [
            SELECT Id
            FROM Pop_User__c
            WHERE Persona__c = :UserInfo.getUserId()
        ];
        
        delete pUser;
        
        Test.startTest();
        Boolean hasException = false;
        try {
            pUser = PopReminderController.getPopUser();
        } catch (Exception e) {
            hasException = true;
        }
        Test.stopTest();
        
        System.assert(hasException, 'Should throw exception.');        
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
        
        List<Pop_Reminder__c> reminders = createPopReminders(2, false);
        
        Test.startTest();
        PopReminderController.createReminders(reminders);
        Test.stopTest();
        
        List<Pop_Reminder__c> results = [
            SELECT ID, Reminder_Description__c
            FROM Pop_Reminder__c
        ];
        
        System.assertEquals(2, results.size(), 'Should return a list of reminders created');
    }
    
    @IsTest
    static void testCreateRemindersFailed() {
        PopReminderController.popReminderDAO = new MockPopReminderDAOServiceImpl();
        
        List<Pop_Reminder__c> reminders = createPopReminders(2, true);
        
        Test.startTest();
        Boolean hasException = false;
        try {
        	PopReminderController.createReminders(reminders);    
        } catch(Exception e) {
            hasException = true;
        }
        Test.stopTest();
        
        System.assert(hasException, 'Should throw exception.');
    }
    
    @IsTest
    static void testUpdateReminders() {
        List<Pop_Reminder__c> reminders = createPopReminders(2, false);
        insert reminders;
        
        List<Pop_Reminder__c> reminders2Update = [
            SELECT Id, Name, Severity__c
            FROM Pop_Reminder__c
            LIMIT 2
        ];
        
        for(Pop_Reminder__c pReminder : reminders2Update) {
            pReminder.Severity__c = PopReminderConstant.LOW_SEVERITY;
        }

        Test.startTest();
        PopReminderController.updateReminder(reminders2Update);
        Test.stopTest();
        
        List<Pop_Reminder__c> results = [
            SELECT Id, Name, Reminder_Description__c, Severity__c
            FROM Pop_Reminder__c
            LIMIT 2
        ];
        
        System.assertEquals(2, results.size(), 'There should be 2 results returned');
        for(Pop_Reminder__c pReminder: results) {
            System.assertEquals(PopReminderConstant.LOW_SEVERITY, pReminder.Severity__c, 'Reminder severity should be low.');
        }
        
    }
    
    @IsTest
    static void testDeleteReminder() {
        Pop_Reminder__c pReminder = createPopReminders(1, false)[0];
        insert pReminder;
        
        Id reminderId = pReminder.Id;
        Test.startTest();
        PopReminderController.deleteReminder(reminderId);
        Test.stopTest();
        
        Boolean hasException = false;
        try {
			Pop_Reminder__c result = [
                SELECT Id, Name
                FROM Pop_Reminder__c
                WHERE Id = :reminderId
        	];            
        } catch (Exception e) {
            hasException = true;
        }
        
        System.assertEquals(true, hasException, 'Should throw exception.');
    }
    
    @IsTest
    static void testGetPickList() {
        String testObject = 'Case';
        String testField = 'Reason';
        
        Test.startTest();
        List<String> resultPicklists = PopReminderController.getPickList(testObject, testField);
        Test.stopTest();
        
        System.assert(resultPicklists.size() > 0, 'Picklists should return.');
    }
    
    @IsTest
    static void testGetPopReminders() {
        Pop_User__c pUser = getPopReminderUser();
        
        List<Pop_Reminder__c> reminders = createPopReminders(2, false);
        insert reminders;
        
        Test.startTest();
        List<Pop_Reminder__c> results = PopReminderController.getPopReminders(pUser.Id);
        Test.stopTest();
        
        System.assertEquals(2, results.size(), 'Should return list of reminders.');
        
    }
    
    private static Pop_User__c getPopReminderUser() {
        return [
            SELECT Id, Name
            FROM Pop_User__c
            LIMIT 1
        ];
    }
    
    private static List<Pop_Reminder__c> createPopReminders(Integer numOfReminders, Boolean triggerException) {
        Pop_User__c pUser = getPopReminderUser();
        
        List<Pop_Reminder__c> reminders = new List<Pop_Reminder__c>();
        for(Integer i=0; i<numOfReminders; i++) {
            Pop_Reminder__c pReminder = new Pop_Reminder__c();
            pReminder.Reminder_Description__c = 'test '+i;
            pReminder.Severity__c = triggerException ? null : PopReminderConstant.HIGH_SEVERITY;
            pReminder.Due_Date__c = Datetime.now().addMinutes(2);
            pReminder.Pop_User__c = pUser.Id;
            reminders.add(pReminder);
        }
        
        return reminders;
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