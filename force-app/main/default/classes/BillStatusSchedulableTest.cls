@IsTest
public class BillStatusSchedulableTest {
	@testSetup
	static void testSetup() {
		Contact contact1 = UtilityTest.createContact('Luis', 'Campos');
		Contact contact2 = UtilityTest.createContact('Diana', 'Gonzalez');
		Account acc = UtilityTest.createAccount();
		Category__c cat = UtilityTest.createCategory('Test');
		Transaction__c transaction1 = UtilityTest.createTransaction(acc, contact1, contact2, System.today().addDays(-30), cat, 'Test description', 20.0);
		Transaction__c transaction2 = UtilityTest.createTransaction(acc, contact2, contact1, System.today().addDays(-30), cat, 'Test description', 35.0);
	}

	@IsTest
	static void withEmailTemplate() {
		EmailTemplate emailTemplate;
		System.runAs(UtilityTest.createUser('Test', 'LN', 'Standard User')) {
			emailTemplate = UtilityTest.createEmailtemplate();
		}

		BillStatusSchedulable schedule = new BillStatusSchedulable();

		Test.StartTest();
		schedule.execute(null);
		Test.stopTest();

		System.assertEquals(true, schedule.endMonthEmailTemplate != null, 'The End Month Email Template must be correctly setted.');
		System.assertEquals(emailTemplate.Id, schedule.endMonthEmailTemplate.Id, 'The End Month Email Template must be correctly setted.');

		System.assertEquals('DEUDOR: Diana COBRADOR: Luis DEUDA: $15.00', schedule.message.getHtmlBody(), 'The email message is not properly set.');
	}

	@IsTest
	static void withoutEmailTemplate() {
		BillStatusSchedulable schedule = new BillStatusSchedulable();

		Test.StartTest();
		schedule.execute(null);
		Test.stopTest();

		System.assertEquals(true, schedule.endMonthEmailTemplate == null, 'The End Month Email Template must be null.');

		System.assertEquals('Diana le debe a Luis la cantidad de $15.00', schedule.message.getPlainTextBody(), 'The email message is not properly set.');
	}

	@IsTest
	static void getMonthTextTest() {
		Test.StartTest();
		BillStatusSchedulable schedule = new BillStatusSchedulable();
		Test.stopTest();

		System.assertEquals('January', schedule.getMonthText(1), 'January is not properly obtained.');
		System.assertEquals('February', schedule.getMonthText(2), 'February is not properly obtained.');
		System.assertEquals('March', schedule.getMonthText(3), 'March is not properly obtained.');
		System.assertEquals('April', schedule.getMonthText(4), 'April is not properly obtained.');
		System.assertEquals('May', schedule.getMonthText(5), 'May is not properly obtained.');
		System.assertEquals('June', schedule.getMonthText(6), 'June is not properly obtained.');
		System.assertEquals('July', schedule.getMonthText(7), 'July is not properly obtained.');
		System.assertEquals('August', schedule.getMonthText(8), 'August is not properly obtained.');
		System.assertEquals('September', schedule.getMonthText(9), 'September is not properly obtained.');
		System.assertEquals('October', schedule.getMonthText(10), 'October is not properly obtained.');
		System.assertEquals('November', schedule.getMonthText(11), 'November is not properly obtained.');
		System.assertEquals('December', schedule.getMonthText(12), 'December is not properly obtained.');
		System.assertEquals('', schedule.getMonthText(13), 'Default case is not properly obtained.');
		System.assertEquals('', schedule.getMonthText(0), 'Default case is not properly obtained.');
	}
}
