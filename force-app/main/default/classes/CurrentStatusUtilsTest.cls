@IsTest(isParallel=true)
public class CurrentStatusUtilsTest {
	@IsTest
	static void getBillsTest() {
		Contact contact1 = UtilityTest.createContact('Luis', 'Campos');
		Contact contact2 = UtilityTest.createContact('Diana', 'Gonzalez');
		Account acc = UtilityTest.createAccount();
		Category__c cat = UtilityTest.createCategory('Test');
		Transaction__c transaction1 = UtilityTest.createTransaction(acc, contact1, contact2, Date.valueOf('2020-08-01'), cat, 'Test description', 20.0);
		Transaction__c transaction2 = UtilityTest.createTransaction(acc, contact2, contact1, Date.valueOf('2020-08-02'), cat, 'Test description', 35.0);
		Transaction__c transaction3 = UtilityTest.createTransaction(acc, contact1, contact2, Date.valueOf('2020-08-03'), cat, 'Test description', 63.8);
		Transaction__c transaction4 = UtilityTest.createTransaction(acc, contact2, contact1, Date.valueOf('2020-08-07'), cat, 'Test description', 5.1);
		Transaction__c transaction5 = UtilityTest.createTransaction(acc, contact1, contact2, Date.valueOf('2020-07-03'), cat, 'Test description', 63.8);
		Transaction__c transaction6 = UtilityTest.createTransaction(acc, contact2, contact1, Date.valueOf('2020-07-07'), cat, 'Test description', 5.1);

		List<AggregateResult> result;
		Test.StartTest();
		result = CurrentStatusUtils.getBills('2020-08');
		Test.stopTest();

		System.assertEquals(2, result.size(), 'Must be 2 result rows');
		System.assertEquals(83.8, (Decimal) result.get(0).get('expr0'), 'Total paid by this contact must be 83.8');
		System.assertEquals(40.1, (Decimal) result.get(1).get('expr0'), 'Total paid by this contact must be 40.1');
	}
}
