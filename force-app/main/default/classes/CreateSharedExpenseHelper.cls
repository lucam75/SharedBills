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
		return [SELECT Id, Name FROM Contact WHERE Active__c = true ORDER BY Name ASC LIMIT 100];        
	}

	@AuraEnabled(Cacheable=true)
	public static Contact getLoggedContact(){
		try{
			if (Schema.sObjectType.Contact.fields.Email.isAccessible()) {
				return [SELECT Id FROM Contact WHERE Email = :UserInfo.getUserEmail() LIMIT 1];
			}else{
				return null;
			}
		}catch(Exception e){
			return null;
		}
	}

	@AuraEnabled(Cacheable=false)
	public static List<LookupSearchResult> search(String searchTerm, List<String> selectedIds, String lookupType) {
		List<LookupSearchResult> results = new List<LookupSearchResult>();
		if(searchTerm != null && searchTerm != ''){
			searchTerm = '%' + searchTerm + '%';
		}else{
			searchTerm = null;
		}
 
		try{
			if(lookupType == 'category_lookup'){
				if(searchTerm == null){
					for(RecentlyViewed cat : [SELECT Id, Name FROM RecentlyViewed WHERE Type = 'Category__c' ORDER BY LastViewedDate DESC LIMIT 5]){
						results.add(new LookupSearchResult(
							cat.Id,
							'Category',
							'custom:custom46',
							cat.Name,
							'Category • ' + cat.Name,
							null
						));
					}
				}else{
					for(Category__c cat : [SELECT Id, Name FROM Category__c WHERE Name LIKE :searchTerm ORDER BY Name ASC]){
						results.add(new LookupSearchResult(
							cat.Id,
							'Category',
							'custom:custom46',
							cat.Name,
							'Category • ' + cat.Name,
							null
						));
					}
				}
			}else if(lookupType == 'account_lookup'){
				if(searchTerm == null){
					Set<Id> recentAccountIds = new Set<Id>();
					for(RecentlyViewed acc : [SELECT Id, Name FROM RecentlyViewed WHERE Type = 'Account' ORDER BY LastViewedDate DESC LIMIT 5]){
						recentAccountIds.add(acc.Id);
					}
					for(Account acc : [SELECT Id, Name, Icon__c, IconUrl__c FROM Account WHERE Id IN :recentAccountIds ORDER BY Name ASC]){
						results.add(new LookupSearchResult(
							acc.Id,
							'Company',
							'standard:account',
							acc.Name,
							'Company • ' + acc.Name,
							acc.IconUrl__c
						));
					}
				}else{
					for(Account acc : [SELECT Id, Name, Icon__c, IconUrl__c FROM Account WHERE Name LIKE :searchTerm ORDER BY Name ASC]){
						results.add(new LookupSearchResult(
							acc.Id,
							'Company',
							'standard:account',
							acc.Name,
							'Company • ' + acc.Name,
							acc.IconUrl__c
						));
					}
				}
			}else if(lookupType == 'event_lookup'){
				if(searchTerm == null){
					for(RecentlyViewed evt : [SELECT Id, Name FROM RecentlyViewed WHERE Type = 'Event__c' ORDER BY LastViewedDate DESC LIMIT 5]){
						results.add(new LookupSearchResult(
							evt.Id,
							'Event',
							'custom:custom20',
							evt.Name,
							'Event • ' + evt.Name,
							null
						));
					}
				}else{
					for(Event__c evt : [SELECT Id, Name FROM Event__c WHERE Name LIKE :searchTerm ORDER BY Name ASC]){
						results.add(new LookupSearchResult(
							evt.Id,
							'Event',
							'custom:custom20',
							evt.Name,
							'Event • ' + evt.Name,
							null
						));
					}
				}
			}
		}catch(Exception e){
			return results;
		}
		System.debug('results: ' + results);
		return results;
	}
}