@IsTest
public class ScheduleWorkTest {

    @IsTest
    static void emailScheduleTest() {
        Test.startTest();
        ScheduleWork sw = new ScheduleWork();
        sw.setEmailSubject('Test Schedule');
        sw.setEmailToAddress('dale@test.com');
        sw.setEmailBody('Test Body');
        Datetime scheduleTime = Datetime.now().addMinutes(1);
        String schCronExp = scheduleTime.format('s m H d M \'?\' yyyy');
        String jobId = System.schedule('Test Schedule Job '+scheduleTime, schCronExp, sw);
        Test.stopTest();
        
        CronTrigger ct = [
            SELECT Id, CronExpression, TimesTriggered, NextFireTime
            FROM CronTrigger
            WHERE Id = :jobId
        ];
        
        System.assertEquals(schCronExp, ct.CronExpression, 'Cron expression should equal.');
        System.assertEquals(0, ct.TimesTriggered, 'The job should not have run yet.');
    }
}