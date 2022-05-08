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
    
    public static void updateStatus(Pop_Reminder__c reminder) {
        if(reminder.Due_Date__c <= Datetime.now() && reminder.Status__c != PopReminderConstant.REMINDER_DUE) {
            reminder.Status__c = PopReminderConstant.REMINDER_DUE;    
        } else if(reminder.Due_Date__c <= Datetime.now().addDays(1) && 
                  reminder.Due_Date__c > Datetime.now() &&
                  reminder.Status__c != PopReminderConstant.REMINDER_ALMOST_DUE) {
            reminder.Status__c = PopReminderConstant.REMINDER_ALMOST_DUE;
        } else if(reminder.Due_Date__c <= Datetime.now().addDays(2) && 
                  reminder.Due_Date__c > Datetime.now().addDays(1) &&
                  reminder.Status__c != PopReminderConstant.REMINDER_COUNTING_DOWN) {
            reminder.Status__c = PopReminderConstant.REMINDER_COUNTING_DOWN;
        }
    }
    
    public static String processDescription(String currDescription, String newDescription) {
        String finalDescription;
        String tableStyle = 'background-color:#eee;border-collapse:collapse';
        String headerStyle = 'background-color:#000;color:white;width:20%';
        String headerStyleWithLongerWidth = 'background-color:#000;color:white;width:50%';
        String rowStyle = 'padding:5px;border:1px solid #000';
        String token = '<tr>'+newDescription+'</tr>';
        if(currDescription == null) {
            finalDescription = '<h3>The following items are due or about to due. Please action!</h3>';
            finalDescription += '<table style="'+tableStyle+'">'+
                '<tr style="'+rowStyle+'">'+
                '<th style="'+headerStyle+'">Due Date</th>'+
                '<th style="'+headerStyleWithLongerWidth+'">Description</th>'+
                '<th style="'+headerStyle+'">Status</th>'+
                '<th style="'+headerStyle+'">Severity</th>'+
                '</tr>';
            finalDescription += token + '</table>';
        } else {
            finalDescription = currDescription.substringBeforeLast('</table>') + token + '</table>';
        }
        
        return finalDescription;
    }
}