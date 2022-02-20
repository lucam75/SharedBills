/**
 * @File Name          : BillStatusSchedulable.cls
 * @Description        :
 * @Author             : Luis Campos (LC)
 * @Group              :
 * @Last Modified By   : Luis Campos (LC)
 * @Last Modified On   : 08-01-2021
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

public with sharing class BillStatusSchedulable implements Schedulable {
	@TestVisible
	private EmailTemplate endMonthEmailTemplate;
	@TestVisible
	private StatusController currentStatus;
	@TestVisible
	private transient Messaging.SingleEmailMessage message;
	public final static String END_MONTH_EMAIL_DEVELOPER_NAME = 'End_Month_Status';

	public BillStatusSchedulable() {
		List<EmailTemplate> emailTemplates = [SELECT Id, Name, Body, HtmlValue, Subject FROM EmailTemplate WHERE developername = :END_MONTH_EMAIL_DEVELOPER_NAME LIMIT 1];
		if (!emailTemplates.isEmpty()) {
			endMonthEmailTemplate = emailTemplates.get(0);
		}
	}

	public void execute(SchedulableContext sc) {
		currentStatus = new StatusController();
		sendEmail();
	}

	public void sendEmail() {
		message = new Messaging.SingleEmailMessage();
		List<String> contactEmails = currentStatus.getContactsEmail();
		if (!contactEmails.isEmpty()) {
			Integer month = System.Today().addDays(-1).month();
			String monthName = getMonthText(month);

			if (endMonthEmailTemplate != null) {
				message.setTemplateId(endMonthEmailTemplate.Id);
				message.Subject = endMonthEmailTemplate.Subject.replace('[LAST_MONTH]', monthName);
				message.setTreatBodiesAsTemplate(true);
				message.setHtmlBody(endMonthEmailTemplate.HtmlValue.replace('%DEUDOR%', currentStatus.getDebtor()).replace('%COBRADOR%', currentStatus.getDebtCollector()).replace('%DEUDA%', currentStatus.getTotalDebtFormatted()));
			} else {
				message.subject = '[SharedBills] Status for ' + monthName;
				message.setPlainTextBody(currentStatus.getDebtor() + ' le debe a ' + currentStatus.getDebtCollector() + ' la cantidad de ' + currentStatus.getTotalDebtFormatted());
			}

			message.toAddresses = contactEmails;
			message.optOutPolicy = 'FILTER';

			Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{ message };
			Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

			if (results[0].success) {
				System.debug(logginglevel.INFO, 'The email was sent successfully.');
			} else {
				System.debug(logginglevel.INFO, 'The email failed to send: ' + results[0].errors[0].message);
			}
		}
	}
	public String getMonthText(Integer month) {
		Map<Integer, String> monthsMap = new Map<Integer, String>{ 1 => 'January', 2 => 'February', 3 => 'March', 4 => 'April', 5 => 'May', 6 => 'June', 7 => 'July', 8 => 'August', 9 => 'September', 10 => 'October', 11 => 'November', 12 => 'December' };
		return monthsMap.containsKey(month) ? monthsMap.get(month) : '';
	}
}
