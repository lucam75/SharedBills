@isTest
public class PostInstallTest {
	@isTest
	static void scheduleJobCreationSuccess() {
		List<CronTrigger> scheduledJobs = [SELECT Id, CronJobDetail.Name, CronJobDetail.Id, State FROM CronTrigger WHERE State != 'COMPLETE' AND CronJobDetail.Name = :PostInstall.JOB_NAME];

		System.assertEquals(0, scheduledJobs.size(), 'No Scheduled jobs with the name should exist.');
		Test.startTest();

		System.Test.testInstall(new PostInstall(), null);

		Test.stopTest();

		List<CronTrigger> scheduledJobsAfter = [SELECT Id, CronJobDetail.Name, CronJobDetail.Id, State FROM CronTrigger WHERE State != 'COMPLETE' AND CronJobDetail.Name = :PostInstall.JOB_NAME];

		System.assertEquals(1, scheduledJobsAfter.size(), 'A Schedule Job correctly named must be created.');
	}

	@isTest
	static void scheduleJobCreationNoNeeded() {
		System.schedule(PostInstall.JOB_NAME, PostInstall.CRON_EXPR, new BillStatusSchedulable());

		List<CronTrigger> scheduledJobs = [SELECT Id, CronJobDetail.Name, CronJobDetail.Id, State FROM CronTrigger WHERE State != 'COMPLETE' AND CronJobDetail.Name = :PostInstall.JOB_NAME];

		System.assertEquals(1, scheduledJobs.size(), 'Scheduled job with the name should exist.');
		Test.startTest();

		System.Test.testInstall(new PostInstall(), null);

		Test.stopTest();

		List<CronTrigger> scheduledJobsAfter = [SELECT Id, CronJobDetail.Name, CronJobDetail.Id, State FROM CronTrigger WHERE State != 'COMPLETE' AND CronJobDetail.Name = :PostInstall.JOB_NAME];

		System.assertEquals(1, scheduledJobsAfter.size(), 'No additional Scheduled Jobs should be created. No exception expected.');
	}
}
