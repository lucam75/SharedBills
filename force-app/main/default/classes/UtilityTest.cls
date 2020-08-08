@IsTest
public class UtilityTest {
	public static EmailTemplate createEmailtemplate() {
		EmailTemplate emailTemplate = new EmailTemplate(developername = BillStatusSchedulable.END_MONTH_EMAIL_DEVELOPER_NAME, Name = 'Test', TemplateType = 'Text', FolderId = UserInfo.getUserId(), Subject = '[LAST_MONTH]', HtmlValue = 'DEUDOR: %DEUDOR% COBRADOR: %COBRADOR% DEUDA: %DEUDA%');
		insert emailTemplate;

		return emailTemplate;
	}

	public static List<Contact> createContacts(Integer numberOfContacts) {
		List<Contact> contactsToInsert = new List<Contact>();
		for (Integer i = 0; i < numberOfContacts; i++) {
			contactsToInsert.add(createContact('Test' + i, 'LN' + i, false));
		}

		insert contactsToInsert;

		return contactsToInsert;
	}

	public static Contact createContact(String firstName, String lastName) {
		return createContact(firstName, lastName, true);
	}

	public static Contact createContact(String firstName, String lastName, Boolean mustInsert) {
		//insert a contact
		Contact contact = new Contact(FirstName = firstName, LastName = lastName, Email = firstName + lastName + '@test.com', Birthdate = Date.today().addMonths(-20 * 12), MailingState = 'CA', OtherPostalCode = '50010');

		if (mustInsert) {
			insert contact;
		}

		return contact;
	}

	public static Account createAccount() {
		Account acc = new Account(Name = 'Test');
		insert acc;

		return acc;
	}

	public static Category__c createCategory(String name) {
		Category__c cat = new Category__c(Name = name);
		insert cat;

		return cat;
	}

	public static Transaction__c createTransaction(Account acc, Contact billedTo, Contact paidBy, Date createdDate, Category__c cat, String description, Decimal amount) {
		Transaction__c transactionToCreate = new Transaction__c(Account__c = acc.Id, Amount__c = amount, Billed_to__c = billedTo.Id, Category__c = cat.Id, Date__c = createdDate, Description__c = description, Paid_By__c = paidBy.Id);

		insert transactionToCreate;

		return transactionToCreate;
	}

	public static Profile getProfile(String profileName) {
		return [SELECT Id FROM Profile WHERE Name = :profileName];
	}

	public static User createUser(String firstName, String lastName, String profileName) {
		Profile p = getProfile(profileName);
		User u = new User(Alias = firstName + lastName, Email = firstName + lastName + '@test.com', EmailEncodingKey = 'UTF-8', LastName = lastName, LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = firstName + lastName + '@test.com');
		insert u;

		return u;
	}
}
