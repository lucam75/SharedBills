/**
 * @description       :
 * @author            : Luis Campos (lucam75@gmail.com)
 * @group             :
 * @last modified on  : 12-27-2020
 * @last modified by  : Luis Campos (LC)
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   08-29-2020   Luis Campos (lucam75@gmail.com)   Initial Version
 **/
trigger TransactionTrigger on Transaction__c(after insert, after delete, after update, after undelete) {
	TransactionHelper.updateEvents();
	TransactionHelper.postChatterDebts();
}
