/**
 * @File Name          : BillStatusSchedulable.cls
 * @Description        :
 * @Author             : Luis Campos (LC)
 * @Group              :
 * @Last Modified By   : Luis Campos (lucam75@gmail.com)
 * @Last Modified On   : 11/1/2019, 5:26:13 PM
 * @Modification Log   :
 * Ver       Date           Author				Modification
 * 1.0    10/28/2019   	Luis Campos (LC)    	Initial Version
 * 1.1	  07/08/2020	Luis Campos (LC)		Fixes and code coverage
 **/

//BillStatusSchedulable abc = new BillStatusSchedulable();
//abc.execute(null);

//BillStatusSchedulable m = new BillStatusSchedulable();
//String sch = '0 0 0 1 * ? *';
//String jobID = system.schedule('Calculate month bills', sch, m);

global with sharing class BillStatusSchedulable implements Schedulable {
	@TestVisible
	private EmailTemplate endMonthEmailTemplate;
	@TestVisible
	private StatusController currentStatus;
	@TestVisible
	private Messaging.SingleEmailMessage message;
	public final static String END_MONTH_EMAIL_DEVELOPER_NAME = 'End_Month_Status';

	public BillStatusSchedulable() {
		List<EmailTemplate> emailTemplates = [SELECT Id, Name, Body, HtmlValue, Subject FROM EmailTemplate WHERE developername = :END_MONTH_EMAIL_DEVELOPER_NAME LIMIT 1];
		if (!emailTemplates.isEmpty()) {
			endMonthEmailTemplate = emailTemplates.get(0);
		}
	}

	global void execute(SchedulableContext sc) {
		currentStatus = new StatusController(true);
		sendEmail();
	}

	public void sendEmail() {
		message = new Messaging.SingleEmailMessage();
		Integer month = System.Today().addDays(-1).month();
		String monthName = getMonthText(month);

		if (endMonthEmailTemplate != null) {
			system.debug('template version');

			message.setTemplateId(endMonthEmailTemplate.Id);
			message.Subject = endMonthEmailTemplate.Subject.replace('[LAST_MONTH]', monthName);
			message.setTreatBodiesAsTemplate(true);
			message.setHtmlBody(endMonthEmailTemplate.HtmlValue.replace('%DEUDOR%', currentStatus.deudor).replace('%COBRADOR%', currentStatus.cobrador).replace('%DEUDA%', currentStatus.totalDebtAmountString));
		} else {
			system.debug('normal version');
			message.subject = '[SharedBills] Status for ' + monthName;
			message.setPlainTextBody(currentStatus.deudor + ' le debe a ' + currentStatus.cobrador + ' la cantidad de ' + currentStatus.totalDebtAmountString);
		}

		message.toAddresses = new List<String>{ currentStatus.emailLuis, currentStatus.emailDiana };
		message.optOutPolicy = 'FILTER';

		Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{ message };
		Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

		if (results[0].success) {
			System.debug('The email was sent successfully.');
		} else {
			System.debug('The email failed to send: ' + results[0].errors[0].message);
		}
	}
	public String getMonthText(Integer month) {
		if (month == 1) {
			return 'January';
		} else if (month == 2) {
			return 'February';
		} else if (month == 3) {
			return 'March';
		} else if (month == 4) {
			return 'April';
		} else if (month == 5) {
			return 'May';
		} else if (month == 6) {
			return 'June';
		} else if (month == 7) {
			return 'July';
		} else if (month == 8) {
			return 'August';
		} else if (month == 9) {
			return 'September';
		} else if (month == 10) {
			return 'October';
		} else if (month == 11) {
			return 'November';
		} else if (month == 12) {
			return 'December';
		} else {
			return '';
		}
	}
}
