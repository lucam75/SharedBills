/**
 * @File Name          : TransactionTriggerTest.cls
 * @Description        :
 * @Author             : Luis Campos (LC)
 * @Group              :
 * @Last Modified By   : Luis Campos (LC)
 * @Last Modified On   : 12-27-2020
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    1/8/2020   Luis Campos (LC)     Initial Version
 **/
@IsTest(SeeAllData=true)
// SeeAllData required because ConnectApi.ChatterFeeds.postFeedElement is used to create Chatter post in Transaction__c trigger.
public class TransactionTriggerTest {
	static void setupTestData() {
		List<Event__c> eventsToCreate = new List<Event__c>();
		List<Transaction__c> transactionsToCreate = new List<Transaction__c>();

		Contact con = UtilityTest.createContact('CT1', 'LT1');
		Category__c category = UtilityTest.createCategory('Category Test');

		for (Integer i = 0; i < 3; i++) {
			eventsToCreate.add(new Event__c(Name = 'Event Test ' + i));
		}

		insert eventsToCreate;

		for (Integer i = 0; i < 50; i++) {
			transactionsToCreate.add(new Transaction__c(Category__c = category.Id, Event__c = eventsToCreate.get(0).Id, Paid_By__c = con.Id, Amount__c = 200.00, Billed_to__c = con.Id, Date__c = System.today(), Description__c = 'Desc Test'));
		}

		for (Integer i = 0; i < 5; i++) {
			transactionsToCreate.add(new Transaction__c(Category__c = category.Id, Event__c = eventsToCreate.get(1).Id, Paid_By__c = con.Id, Amount__c = 200.00, Billed_to__c = con.Id, Date__c = System.today(), Description__c = 'Desc Test'));
		}

		insert transactionsToCreate;
	}
	@IsTest
	static void testEventAmountCalculation() {
		TransactionTriggerTest.setupTestData();
		Test.startTest();
		Event__c event0 = [SELECT Id, Total_spent__c FROM Event__c WHERE Name = 'Event Test 0' LIMIT 1];
		Event__c event1 = [SELECT Id, Total_spent__c FROM Event__c WHERE Name = 'Event Test 1' LIMIT 1];
		Event__c event2 = [SELECT Id, Total_spent__c FROM Event__c WHERE Name = 'Event Test 2' LIMIT 1];

		Test.stopTest();

		System.assertEquals(50 * 200, event0.Total_spent__c, 'The Total spent for this event must be ' + 50 * 200.00);
		System.assertEquals(5 * 200, event1.Total_spent__c, 'The Total spent for this event must be ' + 5 * 200.00);
		System.assertEquals(null, event2.Total_spent__c, 'The Total spent for this event must be empty');
	}

	@IsTest
	static void testEventAmountCalculation2() {
		TransactionTriggerTest.setupTestData();
		Test.startTest();
		Event__c theEvent = [SELECT Id, Total_spent__c FROM Event__c WHERE Name = 'Event Test 0' LIMIT 1];
		List<Transaction__c> transactionsToDelete = [SELECT Id FROM Transaction__c WHERE Event__c = :theEvent.Id LIMIT 25];

		delete transactionsToDelete;

		Event__c event0 = [SELECT Id, Total_spent__c FROM Event__c WHERE Name = 'Event Test 0' LIMIT 1];
		System.assertEquals(25 * 200.00, event0.Total_spent__c, 'The Total spent for this event must be ' + 25 * 200.00);

		List<Transaction__c> transactionsToUpdate = new List<Transaction__c>();
		for (Transaction__c trans : [SELECT Id FROM Transaction__c WHERE Event__c = :theEvent.Id]) {
			trans.Amount__c = 2.00;
			transactionsToUpdate.add(trans);
		}

		update transactionsToUpdate;

		Event__c eventU = [SELECT Id, Total_spent__c FROM Event__c WHERE Name = 'Event Test 0' LIMIT 1];
		System.debug('LCDebug: eventU ' + eventU);
		System.assertEquals(25 * 2.00, eventU.Total_spent__c, 'The Total spent for this event must be ' + 25 * 2.00);

		Test.stopTest();
	}

	@IsTest
	static void postToChatterWhenDebt() {
		Contact con1 = UtilityTest.createContact('C1', 'L1');
		Contact con2 = UtilityTest.createContact('C2', 'L2');
		User u1 = UtilityTest.createUser('C1', 'L1', 'Standard User');
		User u2 = UtilityTest.createUser('C2', 'L2', 'Standard User');
		con1.User__c = u1.Id;
		update con1;
		con2.User__c = u2.Id;
		update con2;

		Category__c category = UtilityTest.createCategory('Cat 1');

		Test.startTest();
		Transaction__c trx = UtilityTest.createTransaction(null, con1, con2, System.today(), category, 'TEST', 200.00);
		Test.stopTest();

		System.assertEquals(true, trx != null, 'Transactions must be created correctly.');
		FeedItem post = [SELECT Id, Body, IsRichText, Type FROM FeedItem WHERE ParentId = :trx.Id LIMIT 1];
		System.assertEquals(post.Body, '@L1, C2 L2 just created this transaction billed to you for 200.00 corresponding to TEST', 'Chatter post body must be correctly setted.');
		System.assertEquals(false, post.IsRichText, 'Chatter post must not be rich text');
		System.assertEquals('TextPost', post.Type, 'Chatter post type must be TextPost');
	}
}
