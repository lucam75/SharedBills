trigger TransactionTrigger on Transaction__c(after insert, after delete, after update, after undelete) {
	TriggerFactory.createHandler(Transaction__c.sObjectType);
}
