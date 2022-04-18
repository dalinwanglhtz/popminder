global class ScheduleWork implements Schedulable {

    global void execute(SchedulableContext SC) {
        // ScheduleWork sw = new ScheduleWork();
        // run at 2022-4-15 4:50pm
        // String sch = '0 50 16 15 4 ? 2022';
        // System.schedule('Testing2', sch, sw);
        System.debug('Do Something');
        
        Messaging.reserveSingleEmailCapacity(1);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toAddresses = new List<String>{'dalinwanglhtz@gmail.com'};
        String replyToAddress = 'dale@test.com';
        String body = '<h1>Do something<h1>';
        mail.setToAddresses(toAddresses);
        mail.setReplyTo(replyToAddress);
        mail.setSenderDisplayName('ReminderBot');
        mail.setSubject('Reminder for action!');
        mail.setHtmlBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
}