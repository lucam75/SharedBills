/**
 * @File Name          : CreateSharedExpenseHelper.cls
 * @Description        :
 * @Author             : Luis Campos (lucam75@gmail.com)
 * @Group              :
 * @Last Modified By   : Luis Campos (LC)
 * @Last Modified On   : 06-25-2021
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    11/10/2019   Luis Campos (lucam75@gmail.com)     Initial Version
 **/
public with sharing class CreateSharedExpenseHelper {
	private static Map<String, String> mapLookupTypeObjectName = new Map<String, String>{ 'category_lookup' => 'Category__c', 'account_lookup' => 'Account__c', 'event_lookup' => 'Event__c' };
	private static Map<String, String> mapLookupTypeObjectIcon = new Map<String, String>{ 'category_lookup' => 'custom:custom46', 'account_lookup' => 'standard:account', 'event_lookup' => 'custom:custom20' };
	private static Map<String, String> mapLookupTypeObjectLabel = new Map<String, String>{ 'category_lookup' => 'Category', 'account_lookup' => 'Account', 'event_lookup' => 'Event' };
	private static Map<String, String> mapLookupTypeObjectRelationshipName = new Map<String, String>{ 'category_lookup' => 'Category__r', 'account_lookup' => 'Account__r', 'event_lookup' => 'Event__r' };

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
		searchTerm = String.isNotBlank(searchTerm) ? '%' + String.escapeSingleQuotes(searchTerm) + '%' : null;

		if (String.isBlank(searchTerm)) {
			results = searchForLastUsed(searchTerm, String.escapeSingleQuotes(lookupType));
		} else {
			results = searchForTerm(searchTerm, String.escapeSingleQuotes(lookupType));
		}

		return results;
	}

	private static List<LookupSearchResult> searchForLastUsed(String searchTerm, String lookupType) {
		List<LookupSearchResult> results = new List<LookupSearchResult>();
		List<String> fieldstoQuery = new List<String>();
		String idFieldName = String.escapeSingleQuotes(mapLookupTypeObjectName.get(lookupType));

		fieldstoQuery.add(idFieldName);
		fieldstoQuery.add(String.escapeSingleQuotes(mapLookupTypeObjectRelationshipName.get(lookupType) + '.Name'));

		if (idFieldName == 'Account__c') {
			fieldstoQuery.add(String.escapeSingleQuotes('Account__r.IconUrl__c'));
		}

		String fieldsToSelectString = String.escapeSingleQuotes(String.join(fieldsToQuery, ', '));

		for (AggregateResult aggResult : Database.query('SELECT ' + fieldsToSelectString + ' FROM Transaction__c WHERE CreatedById = \'' + UserInfo.getUserId() + '\' GROUP BY ' + fieldsToSelectString + ' HAVING ' + idFieldName + ' != null ORDER BY MIN(CreatedDate) DESC')) {
			LookupSearchResult lsr = new LookupSearchResult();
			lsr.setId((Id) aggResult.get(mapLookupTypeObjectName.get(lookupType)));
			lsr.setIcon(mapLookupTypeObjectIcon.get(lookupType));
			lsr.setTitle(String.valueOf(aggResult.get('Name')));
			lsr.setSubtitle(mapLookupTypeObjectLabel.get(lookupType) + ' • ' + aggResult.get('Name'));
			lsr.setImageUrl(mapLookupTypeObjectName.get(lookupType) == 'Account__c' ? (String) aggResult.get('IconUrl__c') : '');
			results.add(lsr);
		}

		return results;
	}

	private static List<LookupSearchResult> searchForTerm(String searchTerm, String lookupType) {
		List<LookupSearchResult> results = new List<LookupSearchResult>();
		List<String> fieldstoQuery = new List<String>();
		String fromObject = mapLookupTypeObjectName.get(lookupType);

		if (fromObject == 'Account__c') {
			fromObject = 'Account';
		}
		fieldstoQuery.add('Id');
		fieldstoQuery.add('Name');

		if (Utils.hasFieldInObject('IconUrl__c', fromObject)) {
			fieldstoQuery.add('IconUrl__c');
		}

		String fieldsToSelectString = String.escapeSingleQuotes(String.join(fieldsToQuery, ', '));

		for (sObject record : Database.query('SELECT ' + fieldsToSelectString + ' FROM ' + fromObject + ' WHERE Name LIKE :searchTerm WITH SECURITY_ENFORCED ORDER BY Name ASC')) {
			LookupSearchResult lsr = new LookupSearchResult();
			lsr.setId((Id) record.get('Id'));
			lsr.setIcon(mapLookupTypeObjectIcon.get(lookupType));
			lsr.setTitle(String.valueOf(record.get('Name')));
			lsr.setSubtitle(mapLookupTypeObjectLabel.get(lookupType) + ' • ' + record.get('Name'));
			lsr.setImageUrl(mapLookupTypeObjectName.get(lookupType) == 'Account__c' ? (String) record.get('IconUrl__c') : '');
			results.add(lsr);
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

		public LookupSearchResult() {
			id = null;
			icon = '';
			title = '';
			subtitle = '';
			imageUrl = '';
		}

		private void setId(Id id) {
			this.id = id;
		}

		private void setIcon(String icon) {
			this.icon = icon;
		}

		private void setTitle(String title) {
			this.title = title;
		}

		private void setSubtitle(String subtitle) {
			this.subtitle = subtitle;
		}

		private void setImageUrl(String imageUrl) {
			this.imageUrl = imageUrl;
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
