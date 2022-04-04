public virtual class MockPopReminderDAOService implements PopReminderDAO {
    
    public virtual Pop_User__c getPopReminderUser() {
        return null;
    }
    
    public virtual User getCurrentUser() {
        return null;
    }
    
    public virtual Pop_Reminder__c selectReminderById(String reordId) {
        return null;
    }
    
    public virtual List<Pop_Reminder__c> selectRemindersByUserId(String userId) {
        return null;
    }
}