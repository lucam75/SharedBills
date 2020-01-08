/**
 * @File Name          : CreateSharedExpenseHelper.cls
 * @Description        : 
 * @Author             : Luis Campos (lucam75@gmail.com)
 * @Group              : 
 * @Last Modified By   : Luis Campos (LC)
 * @Last Modified On   : 11/11/2019, 4:42:06 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    11/10/2019   Luis Campos (lucam75@gmail.com)     Initial Version
**/
public with sharing class CreateSharedExpenseHelper {
    
    @AuraEnabled(Cacheable=true)
    public static List<Contact> getAllContacts() {
	    return [SELECT Id, Name FROM Contact ORDER BY Name ASC LIMIT 100];        
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
}