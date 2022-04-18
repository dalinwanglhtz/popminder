global class ScheduleWork implements Schedulable {
    private String emailToAddress;
    private String emailBody;
    
    global ScheduleWork(String emailTo) {
        emailToAddress = emailTo;
    }
    
    global void setEmailBody(String body) {
        emailBody = body;
    }

    global void execute(SchedulableContext SC) {
        // ScheduleWork sw = new ScheduleWork();
        // run at 2022-4-15 4:50pm
        // String sch = '0 50 16 15 4 ? 2022';
        // System.schedule('Testing2', sch, sw);
		PopReminderUtil.sendEmail(emailToAddress, 'Reminder for today\'s action', emailBody);
    }
}