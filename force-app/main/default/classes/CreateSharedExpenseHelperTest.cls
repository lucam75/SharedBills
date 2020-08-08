@IsTest
public class CreateSharedExpenseHelperTest {
	@IsTest
	static void getAllContactsNoActive() {
		List<Contact> allContacts = UtilityTest.createContacts(5);

		List<Contact> returnedContacts;

		Test.startTest();
		returnedContacts = CreateSharedExpenseHelper.getAllContacts();
		Test.stopTest();

		System.assertEquals(0, returnedContacts.size(), 'Must be 0 Active contacts');
	}

	static void getAllContactsActive() {
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
		User u = UtilityTest.createUser('LCF', 'LCL', 'System Administrator');
		Contact con = UtilityTest.createContact('LCF', 'LCL');

		Contact loggedContact;

		Test.startTest();
		System.runAs(u) {
			loggedContact = CreateSharedExpenseHelper.getLoggedContact();
		}
		Test.stopTest();

		System.assertEquals(loggedContact.Id, con.Id, 'The logged contact is not properly obtained.');
	}

	@IsTest
	static void searchForCategory() {
		Category__c food = UtilityTest.createCategory('Food');
		Category__c streetFood = UtilityTest.createCategory('Street Food');
		Category__c clothes = UtilityTest.createCategory('Clothes');

		List<CreateSharedExpenseHelper.LookupSearchResult> results;

		Test.startTest();
		results = CreateSharedExpenseHelper.search('oo', 'category_lookup');
		Test.stopTest();

		System.assertEquals(2, results.size(), 'Must return 2 categories');
	}

	@IsTest
	static void searchForCategoryWithoutSearchTerm() {
		Category__c food = UtilityTest.createCategory('Food');
		Category__c streetFood = UtilityTest.createCategory('Street Food');
		Category__c clothes = UtilityTest.createCategory('Clothes');

		List<CreateSharedExpenseHelper.LookupSearchResult> results;

		Test.startTest();
		results = CreateSharedExpenseHelper.search(null, 'category_lookup');
		Test.stopTest();

		System.assertEquals(3, results.size(), 'Must return 3 categories');
	}

	@IsTest
	static void searchForAccount() {
		Account internet = UtilityTest.createAccount('Internet');
		Account sportBrand1 = UtilityTest.createAccount('Sport Brand1');
		Account sportBrand2 = UtilityTest.createAccount('Sport Brand2');

		List<CreateSharedExpenseHelper.LookupSearchResult> results;

		Test.startTest();
		results = CreateSharedExpenseHelper.search('rand', 'account_lookup');
		Test.stopTest();

		System.assertEquals(2, results.size(), 'Must return 2 accounts');
	}

	@IsTest
	static void searchForAccountWithoutSearchTerm() {
		Account internet = UtilityTest.createAccount('Internet');
		Account sportBrand1 = UtilityTest.createAccount('Sport Brand1');
		Account sportBrand2 = UtilityTest.createAccount('Sport Brand2');

		List<CreateSharedExpenseHelper.LookupSearchResult> results;

		Test.startTest();
		results = CreateSharedExpenseHelper.search(null, 'account_lookup');
		Test.stopTest();

		System.assertEquals(3, results.size(), 'Must return 3 accounts');
	}

	@IsTest
	static void searchForEvent() {
		Event__c travel1 = UtilityTest.createEvent('Travel to beach');
		Event__c travel2 = UtilityTest.createEvent('Travel to Mountains');
		Event__c disaster = UtilityTest.createEvent('Tropical storm');

		List<CreateSharedExpenseHelper.LookupSearchResult> results;

		Test.startTest();
		results = CreateSharedExpenseHelper.search('trav', 'event_lookup');
		Test.stopTest();

		System.assertEquals(2, results.size(), 'Must return 2 events');
	}

	@IsTest
	static void searchForEventWithoutSearchTerm() {
		Event__c travel1 = UtilityTest.createEvent('Travel to beach');
		Event__c travel2 = UtilityTest.createEvent('Travel to Mountains');
		Event__c disaster = UtilityTest.createEvent('Tropical storm');

		List<CreateSharedExpenseHelper.LookupSearchResult> results;

		Test.startTest();
		results = CreateSharedExpenseHelper.search(null, 'event_lookup');
		Test.stopTest();

		System.assertEquals(3, results.size(), 'Must return 3 events');
	}
}
