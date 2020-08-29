@IsTest
public with sharing class StatusControllerTest {
	@IsTest
	static void dianaDebtScenario() {
		Contact contact1 = UtilityTest.createContact('Luis', 'Campos');
		Contact contact2 = UtilityTest.createContact('Diana', 'Gonzalez');
		Account acc = UtilityTest.createAccount();
		Category__c cat = UtilityTest.createCategory('Test');

		Transaction__c transaction1 = UtilityTest.createTransaction(acc, contact1, contact2, System.today().addDays(-30), cat, 'Test description', 20.0);
		Transaction__c transaction2 = UtilityTest.createTransaction(acc, contact2, contact1, System.today().addDays(-30), cat, 'Test description', 35.0);

		Test.startTest();
		StatusController status = new StatusController();
		Test.stopTest();

		System.assertEquals('Diana', status.getDebtor(), 'Debtor must be Diana');
		System.assertEquals('Luis', status.getDebtCollector(), 'Debt collector must be Luis');
		System.assertEquals('$15.00', status.getTotalDebtFormatted(), 'Total debt must be $15.00');
	}

	@IsTest
	static void luisDebtScenario() {
		Contact contact1 = UtilityTest.createContact('Luis', 'Campos');
		Contact contact2 = UtilityTest.createContact('Diana', 'Gonzalez');
		Account acc = UtilityTest.createAccount();
		Category__c cat = UtilityTest.createCategory('Test');

		Transaction__c transaction1 = UtilityTest.createTransaction(acc, contact2, contact1, System.today().addDays(-30), cat, 'Test description', 20.0);
		Transaction__c transaction2 = UtilityTest.createTransaction(acc, contact1, contact2, System.today().addDays(-30), cat, 'Test description', 35.0);

		Test.startTest();
		StatusController status = new StatusController();
		Test.stopTest();

		System.assertEquals('Luis', status.getDebtor(), 'Debtor must be Luis');
		System.assertEquals('Diana', status.getDebtCollector(), 'Debt collector must be Diana');
		System.assertEquals('$15.00', status.getTotalDebtFormatted(), 'Total debt must be $15.00');
	}

	@IsTest
	static void getContactsEmailCorrectly() {
		Contact contact1 = UtilityTest.createContact('Luis', 'Campos');
		Contact contact2 = UtilityTest.createContact('Diana', 'Gonzalez');
		Account acc = UtilityTest.createAccount();
		Category__c cat = UtilityTest.createCategory('Test');

		Transaction__c transaction1 = UtilityTest.createTransaction(acc, contact2, contact1, System.today().addDays(-30), cat, 'Test description', 20.0);
		Transaction__c transaction2 = UtilityTest.createTransaction(acc, contact1, contact2, System.today().addDays(-30), cat, 'Test description', 35.0);

		Test.startTest();
		StatusController status = new StatusController();
		Test.stopTest();

		System.assertEquals(new List<String>{ 'luiscampos@test.com', 'dianagonzalez@test.com' }, status.getContactsEmail(), 'Email address must be correct.');
	}
}
