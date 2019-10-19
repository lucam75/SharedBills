public with sharing class CreateExpenseExtension {

    
    ApexPages.StandardController controller;
    public Transaction__c transactionItem {get; set;}
    public List<Contact> contacts {get;set;}
    public List<String> selectedContacts {get;set;}
    public List<SelectOption> contactsOption {get;set;}
    public Double billedToDiana {get;set;}
    public Double billedToLuis {get;set;}
    
    public CreateExpenseExtension() {
        System.debug('Create Expense');
        transactionItem = new Transaction__c();
        contactsOption = new List<SelectOption>();
        selectedContacts = new List<String>();
        
        String userName = UserInfo.getUserName();
        User activeUser = [Select Email From User where Username = : userName limit 1];
        String userEmail = activeUser.Email;
        System.debug(userEmail);

        contacts = [SELECT Id, Name, Email FROM Contact WHERE Active__c = true ORDER BY Name ASC];
        
        for(Contact contact : contacts){
            contactsOption.add(new SelectOption(contact.Id, contact.Name));
            if(contact.Email == userEmail){
                transactionItem.Paid_By__c = contact.Id;
            }
        }
    }

    public void Save(){
    
     try{   
             
        // insert payincrease;
        String billedToDiana = Apexpages.currentPage().getParameters().get('billedToDiana');
        String billedToLuis = Apexpages.currentPage().getParameters().get('billedToLuis');

        Transaction__c transactionForLuis = transactionItem.Clone(false, true);
        Transaction__c transactionForDiana = transactionItem.Clone(false, true);
        
        transactionForLuis.Amount__c = decimal.valueOf(billedToLuis);
        transactionForDiana.Amount__c = decimal.valueOf(billedToDiana);
        transactionForLuis.Billed_to__c = '0033j00003CIp7hAAD';
        transactionForDiana.Billed_to__c = '0033j00003CIp8LAAT';
        
        List<Transaction__c> transactionsToCreate = new List<Transaction__c>();
        transactionsToCreate.add(transactionForLuis);
        transactionsToCreate.add(transactionForDiana);
        
        insert transactionsToCreate;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Expenses created!'));

     }
     
     catch (Exception ex) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
         system.debug(ex);
     }
    } 
}