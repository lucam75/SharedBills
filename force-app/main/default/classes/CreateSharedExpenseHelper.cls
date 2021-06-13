/**
 * @File Name          : CreateSharedExpenseHelper.cls
 * @Description        :
 * @Author             : Luis Campos (lucam75@gmail.com)
 * @Group              :
 * @Last Modified By   : Luis Campos (LC)
 * @Last Modified On   : 06-13-2021
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    11/10/2019   Luis Campos (lucam75@gmail.com)     Initial Version
 **/
public with sharing class CreateSharedExpenseHelper {
	@AuraEnabled(Cacheable=true)
	public static List<Contact> getAllContacts() {
		return [SELECT Id, Name FROM Contact WHERE Active__c = TRUE WITH SECURITY_ENFORCED ORDER BY Name ASC LIMIT 100];
	}

	@AuraEnabled(Cacheable=true)
	public static Contact getLoggedContact() {
		Contact con = null;
		if (Schema.sObjectType.Contact.fields.User__c.isAccessible()) {
			List<Contact> contacts = [SELECT Id FROM Contact WHERE User__c = :UserInfo.getUserId() WITH SECURITY_ENFORCED];
			con = (!contacts.isEmpty()) ? contacts.get(0) : null;
		}
		return con;
	}

	@AuraEnabled(Cacheable=false)
	public static List<LookupSearchResult> search(String searchTerm, String lookupType) {
		List<LookupSearchResult> results = new List<LookupSearchResult>();
		searchTerm = String.isNotBlank(searchTerm) ? '%' + searchTerm + '%' : null;

		Map<String, String> mapLookupTypeObjectName = new Map<String, String>{ 'category_lookup' => 'Category__c', 'account_lookup' => 'Account', 'event_lookup' => 'Event__c' };
		Map<String, String> mapLookupTypeObjectIcon = new Map<String, String>{ 'category_lookup' => 'custom:custom46', 'account_lookup' => 'standard:account', 'event_lookup' => 'custom:custom20' };
		Map<String, String> mapLookupTypeObjectSubtitle = new Map<String, String>{ 'category_lookup' => 'Category', 'account_lookup' => 'Account', 'event_lookup' => 'Event' };

		String objectName = String.escapeSingleQuotes(mapLookupTypeObjectName.get(lookupType));

		if (searchTerm == null) {
			for (RecentlyViewed record : [SELECT Id, Name FROM RecentlyViewed WHERE Type = :objectName WITH SECURITY_ENFORCED ORDER BY LastViewedDate DESC LIMIT 5]) {
				results.add(new LookupSearchResult(record, mapLookupTypeObjectIcon.get(lookupType), mapLookupTypeObjectSubtitle.get(lookupType) + ' • ' + record.Name));
			}
		} else {
			List<String> fieldstoQuery = new List<String>{ 'Id', 'Name' };
			if (Utils.hasFieldInObject('IconUrl__c', objectName)) {
				fieldstoQuery.add('IconUrl__c');
			}
			for (SObject record : Database.query('SELECT ' + String.join(fieldsToQuery, ', ') + ' FROM ' + objectName + ' WHERE Name LIKE :searchTerm WITH SECURITY_ENFORCED ORDER BY Name ASC')) {
				results.add(new LookupSearchResult(record, mapLookupTypeObjectIcon.get(lookupType), mapLookupTypeObjectSubtitle.get(lookupType) + ' • ' + record.get('Name')));
			}
		}

		return results;
	}

	/**
	 * Class used to serialize a single Lookup search result item
	 * The Lookup controller returns a List<LookupSearchResult> when sending search result back to Lightning
	 */
	public class LookupSearchResult {
		private Id id;
		private String icon;
		private String title;
		private String subtitle;
		private String imageUrl;

		public LookupSearchResult(sObject record, String icon, String subtitle) {
			this.id = (Id) record.get('Id');
			this.icon = icon;
			this.title = String.valueOf(record.get('Name'));
			this.subtitle = subtitle;
			this.imageUrl = Utils.hasSObjectField('IconUrl__c', record) ? String.valueOf(record.get('IconUrl__c')) : null;
		}

		@AuraEnabled
		public Id getId() {
			return id;
		}

		@AuraEnabled
		public String getIcon() {
			return icon;
		}

		@AuraEnabled
		public String getTitle() {
			return title;
		}

		@AuraEnabled
		public String getSubtitle() {
			return subtitle;
		}

		@AuraEnabled
		public String getImageUrl() {
			return imageUrl;
		}
	}
}
