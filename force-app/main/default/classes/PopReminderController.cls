public class PopReminderController {

    @auraenabled(cacheable=true)
    public static void createReminders(List<Pop_Reminder__c> reminders) {
        if(!reminders.isEmpty()) {
            insert reminders;
        }
    }
    
    @auraenabled(cacheable=true)
    public static List<String> getPickList(String objectName, String fieldName) {
        List<String> values = new List<String>();
        List<Schema.DescribeSObjectResult> results = Schema.describeSObjects(new List<String> {objectName});
        
        for(Schema.DescribeSObjectResult res: results) {
            for(Schema.PicklistEntry entry: res.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) {
                if(entry.isActive()) {
                    values.add(entry.getValue());
                }
            }
        }
        return values;
    }
    
    @auraenabled(cacheable=true)
    public static List<Pop_Reminder__c> getPopReminders(String userId) {
        return [
            SELECT Id, Name, Reminder_Description__c, Due_Date__c, Severity__c
            FROM Pop_Reminder__c
            WHERE Pop_User__c = :userId
        ];
    }
}