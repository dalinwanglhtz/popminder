public class PopReminderUtil {

    public static void sendEmail(String toAddress, String subject, String body) {
        Messaging.reserveSingleEmailCapacity(1);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toAddresses = new List<String>{toAddress};
        String replyToAddress = 'dale@test.com';
        mail.setToAddresses(toAddresses);
        mail.setReplyTo(replyToAddress);
        mail.setSenderDisplayName('ReminderBot');
        mail.setSubject(subject);
        mail.setHtmlBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
    
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
    
    public static void scheduleReminder(Pop_Reminder__c pReminder, Map<Id, Pop_User__c> pUserMap) {
        Pop_User__c pUser = pUserMap.get(pReminder.Pop_User__c);
        ScheduleWork sw = new ScheduleWork();
        sw.setEmailToAddress(pUser.Email__c);
        sw.setEmailSubject('Reminder for action!!');
        sw.setEmailBody(pReminder.Reminder_Description__c);
        Datetime scheduleTime = pReminder.Due_Date__c;
        String schCronExp = scheduleTime.format('s m H d M \'?\' yyyy');
        System.schedule('Reminder '+pReminder.Id, schCronExp, sw);
    }
}