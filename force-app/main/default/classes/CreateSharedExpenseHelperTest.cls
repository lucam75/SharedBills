@IsTest
public class CreateSharedExpenseHelperTest {
	@IsTest
	static void getAllContactsNoActive() {
		UtilityTest.createContacts(5);

		List<Contact> returnedContacts;

		Test.startTest();
		returnedContacts = CreateSharedExpenseHelper.getAllContacts();
		Test.stopTest();

		System.assertEquals(0, returnedContacts.size(), 'Must be 0 Active contacts');
	}

	@isTest
	private static void getAllContactsActive() {
		List<Contact> allContacts = UtilityTest.createContacts(5);

		for (Contact con : allContacts) {
			con.Active__c = true;
		}

		update allContacts;

		List<Contact> returnedContacts;

		Test.startTest();
		returnedContacts = CreateSharedExpenseHelper.getAllContacts();
		Test.stopTest();

		System.assertEquals(5, returnedContacts.size(), 'Must be 5 Active contacts');
	}

	@IsTest
	static void getLoggedContactTest() {
		User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Shared_Bills_User'];
		insert new PermissionSetAssignment(AssigneeId = runningUser.Id, PermissionSetId = ps.Id);
		System.runAs(runningUser) {
			Contact con = UtilityTest.createContact('LCF', 'LCL', UserInfo.getUserId());

			Contact loggedContact;
			Test.startTest();
			loggedContact = CreateSharedExpenseHelper.getLoggedContact();
			Test.stopTest();

			System.assertEquals(loggedContact.Id, con.Id, 'The logged contact is not properly obtained.');
		}
	}

	@IsTest
	static void searchForCategory() {
		UtilityTest.createCategory('Food');
		UtilityTest.createCategory('Street Food');
		UtilityTest.createCategory('Clothes');

		List<CreateSharedExpenseHelper.LookupSearchResult> results;

		Test.startTest();
		results = CreateSharedExpenseHelper.search('oo', 'category_lookup');
		Test.stopTest();

		System.assertEquals(2, results.size(), 'Must return 2 categories');
	}

	@IsTest
	static void searchForCategoryWithoutSearchTerm() {
		UtilityTest.createCategory('Food');
		UtilityTest.createCategory('Street Food');
		UtilityTest.createCategory('Clothes');

		List<CreateSharedExpenseHelper.LookupSearchResult> results;

		Test.startTest();
		results = CreateSharedExpenseHelper.search(null, 'category_lookup');
		Test.stopTest();

		System.assertEquals(true, results.size() <= 5, 'Must return not more than 5 categories');
	}

	@IsTest
	static void searchForAccount() {
		UtilityTest.createAccount('Internet');
		UtilityTest.createAccount('Sport Brand1');
		UtilityTest.createAccount('Sport Brand2');

		List<CreateSharedExpenseHelper.LookupSearchResult> results;

		Test.startTest();
		results = CreateSharedExpenseHelper.search('rand', 'account_lookup');
		Test.stopTest();

		System.assertEquals(2, results.size(), 'Must return 2 accounts');
	}

	@IsTest
	static void searchForAccountWithoutSearchTerm() {
		UtilityTest.createAccount('Internet');
		UtilityTest.createAccount('Sport Brand1');
		UtilityTest.createAccount('Sport Brand2');

		List<CreateSharedExpenseHelper.LookupSearchResult> results;

		Test.startTest();
		results = CreateSharedExpenseHelper.search(null, 'account_lookup');
		Test.stopTest();

		System.assertEquals(true, results.size() <= 5, 'Must return not more than 5 accounts');
	}

	@IsTest
	static void searchForEvent() {
		UtilityTest.createEvent('Travel to beach');
		UtilityTest.createEvent('Travel to Mountains');
		UtilityTest.createEvent('Tropical storm');

		List<CreateSharedExpenseHelper.LookupSearchResult> results;

		Test.startTest();
		results = CreateSharedExpenseHelper.search('trav', 'event_lookup');
		Test.stopTest();

		System.assertEquals(2, results.size(), 'Must return 2 events');
	}

	@IsTest
	static void searchForEventWithoutSearchTerm() {
		UtilityTest.createEvent('Travel to beach');
		UtilityTest.createEvent('Travel to Mountains');
		UtilityTest.createEvent('Tropical storm');

		List<CreateSharedExpenseHelper.LookupSearchResult> results;

		Test.startTest();
		results = CreateSharedExpenseHelper.search(null, 'event_lookup');
		Test.stopTest();

		System.assertEquals(true, results.size() <= 5, 'Must return not more than 5 events');
	}

	@IsTest
	static void lookupMethodsTest() {
		Event__c travel1 = UtilityTest.createEvent('Travel to beach');

		List<CreateSharedExpenseHelper.LookupSearchResult> results;

		Test.startTest();
		results = CreateSharedExpenseHelper.search('beach', 'event_lookup');
		Test.stopTest();

		System.assertEquals(travel1.Id, results.get(0).getId(), 'Must return the correct field value.');
		System.assertEquals('custom:custom20', results.get(0).getIcon(), 'Must return the correct field value.');
		System.assertEquals(travel1.Name, results.get(0).getTitle(), 'Must return the correct field value.');
		System.assertEquals('Event • ' + travel1.Name, results.get(0).getSubtitle(), 'Must return the correct field value.');
		System.assertEquals('', results.get(0).getImageUrl(), 'Must return the correct field value.');
	}

	@IsTest
	static void searchForLastUsedAccountsInTrx() {
		UtilityTest.createAccount('Sport Brand1');
		UtilityTest.createAccount('Sport Brand2');

		Contact contact1 = UtilityTest.createContact('Luis', 'Campos');
		Contact contact2 = UtilityTest.createContact('Diana', 'Gonzalez');
		Account acc = UtilityTest.createAccount('Internet');
		Category__c cat = UtilityTest.createCategory('Test');
		UtilityTest.createTransaction(acc, contact1, contact2, Date.valueOf('2020-08-01'), cat, 'Test description', 20.0);

		List<CreateSharedExpenseHelper.LookupSearchResult> results;

		Test.startTest();
		results = CreateSharedExpenseHelper.search(null, 'account_lookup');
		Test.stopTest();

		System.assertEquals(true, results.size() == 1, 'Must return just 1 account');
		System.assertEquals(acc.Id, results.get(0).getId(), 'The account returned is not the expected.');
	}
}
