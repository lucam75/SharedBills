/**
 * @File Name          : CreateSharedExpenseHelper.cls
 * @Description        : 
 * @Author             : Luis Campos (lucam75@gmail.com)
 * @Group              : 
 * @Last Modified By   : Luis Campos (lucam75@gmail.com)
 * @Last Modified On   : 11/10/2019, 2:19:32 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    11/10/2019   Luis Campos (lucam75@gmail.com)     Initial Version
**/
public with sharing class CreateSharedExpenseHelper {
    
    @AuraEnabled(Cacheable=true)
    public static List<Contact> getAllContacts() {
	    return [SELECT Id, Name FROM Contact ORDER BY Name ASC LIMIT 100];        
    }
}