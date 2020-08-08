/**
 * @File Name          : CreateSharedExpenseHelper.cls
 * @Description        :
 * @Author             : Luis Campos (lucam75@gmail.com)
 * @Group              :
 * @Last Modified By   : Luis Campos (LC)
 * @Last Modified On   : 3/23/2020, 12:47:15 PM
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    11/10/2019   Luis Campos (lucam75@gmail.com)     Initial Version
 **/
public with sharing class CreateSharedExpenseHelper {
	@AuraEnabled(Cacheable=true)
	public static List<Contact> getAllContacts() {
		return [SELECT Id, Name FROM Contact WHERE Active__c = TRUE ORDER BY Name ASC LIMIT 100];
	}

	@AuraEnabled(Cacheable=true)
	public static Contact getLoggedContact() {
		Contact con = null;
		if (Schema.sObjectType.Contact.fields.Email.isAccessible()) {
			List<Contact> contacts = [SELECT Id FROM Contact WHERE Email = :UserInfo.getUserEmail()];
			con = (!contacts.isEmpty()) ? contacts.get(0) : null;
		}

		return con;
	}

	@AuraEnabled(Cacheable=true)
	public static List<LookupSearchResult> search(String searchTerm, String lookupType) {
		List<LookupSearchResult> results = new List<LookupSearchResult>();
		if (searchTerm != null && searchTerm != '') {
			searchTerm = '%' + searchTerm + '%';
		} else {
			searchTerm = null;
		}

		if (lookupType == 'category_lookup') {
			if (searchTerm == null) {
				for (RecentlyViewed cat : [SELECT Id, Name FROM RecentlyViewed WHERE Type = 'Category__c' ORDER BY LastViewedDate DESC LIMIT 5]) {
					results.add(new LookupSearchResult(cat.Id, 'Category', 'custom:custom46', cat.Name, 'Category • ' + cat.Name, null));
				}
			} else {
				for (Category__c cat : [SELECT Id, Name FROM Category__c WHERE Name LIKE :searchTerm ORDER BY Name ASC]) {
					results.add(new LookupSearchResult(cat.Id, 'Category', 'custom:custom46', cat.Name, 'Category • ' + cat.Name, null));
				}
			}
		} else if (lookupType == 'account_lookup') {
			if (searchTerm == null) {
				Set<Id> recentAccountIds = new Set<Id>();
				for (RecentlyViewed acc : [SELECT Id, Name FROM RecentlyViewed WHERE Type = 'Account' ORDER BY LastViewedDate DESC LIMIT 5]) {
					recentAccountIds.add(acc.Id);
				}
				for (Account acc : [SELECT Id, Name, Icon__c, IconUrl__c FROM Account WHERE Id IN :recentAccountIds ORDER BY Name ASC]) {
					results.add(new LookupSearchResult(acc.Id, 'Company', 'standard:account', acc.Name, 'Company • ' + acc.Name, acc.IconUrl__c));
				}
			} else {
				for (Account acc : [SELECT Id, Name, Icon__c, IconUrl__c FROM Account WHERE Name LIKE :searchTerm ORDER BY Name ASC]) {
					results.add(new LookupSearchResult(acc.Id, 'Company', 'standard:account', acc.Name, 'Company • ' + acc.Name, acc.IconUrl__c));
				}
			}
		} else if (lookupType == 'event_lookup') {
			if (searchTerm == null) {
				for (RecentlyViewed evt : [SELECT Id, Name FROM RecentlyViewed WHERE Type = 'Event__c' ORDER BY LastViewedDate DESC LIMIT 5]) {
					results.add(new LookupSearchResult(evt.Id, 'Event', 'custom:custom20', evt.Name, 'Event • ' + evt.Name, null));
				}
			} else {
				for (Event__c evt : [SELECT Id, Name FROM Event__c WHERE Name LIKE :searchTerm ORDER BY Name ASC]) {
					results.add(new LookupSearchResult(evt.Id, 'Event', 'custom:custom20', evt.Name, 'Event • ' + evt.Name, null));
				}
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
		private String sObjectType;
		private String icon;
		private String title;
		private String subtitle;
		private String imageUrl;

		public LookupSearchResult(Id id, String sObjectType, String icon, String title, String subtitle, String imageUrl) {
			this.id = id;
			this.sObjectType = sObjectType;
			this.icon = icon;
			this.title = title;
			this.subtitle = subtitle;
			this.imageUrl = imageUrl;
		}

		@AuraEnabled
		public Id getId() {
			return id;
		}

		@AuraEnabled
		public String getSObjectType() {
			return sObjectType;
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
