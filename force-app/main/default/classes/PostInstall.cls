public without sharing class PostInstall implements InstallHandler {
	@TestVisible
	private static final string JOB_NAME = 'Calculate Monthly Bills';
	@TestVisible
	private static final string CRON_EXPR = '0 0 0 1 * ? *';

	public void onInstall(InstallContext context) {
		PostInstall.scheduleJob();
	}

	private static void scheduleJob() {
		List<CronTrigger> job = [SELECT Id, CronJobDetail.Name, CronJobDetail.Id, State FROM CronTrigger WHERE State != 'COMPLETE' AND CronJobDetail.Name = :JOB_NAME];

		if (job.isEmpty()) {
			System.schedule(JOB_NAME, CRON_EXPR, new BillStatusSchedulable());
		}
	}
}
