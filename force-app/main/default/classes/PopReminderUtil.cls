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
}