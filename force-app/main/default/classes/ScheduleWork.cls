// ScheduleWork sw = new ScheduleWork();
// run at 2022-4-15 4:50pm
// String sch = '0 50 16 15 4 ? 2022';
// System.schedule('Testing2', sch, sw);
global class ScheduleWork implements Schedulable {
    private String emailToAddress;
    private String emailBody;
    private String emailSubject;
    
    global void setEmailToAddress(String emailTo) {
        emailToAddress = emailTo;
    }
    
    global void setEmailBody(String body) {
        emailBody = body;
    }
    
    global void setEmailSubject(String subject) {
        emailSubject = subject;
    }

    global void execute(SchedulableContext SC) {
		PopReminderUtil.sendEmail(emailToAddress, emailSubject, emailBody);
    }
}