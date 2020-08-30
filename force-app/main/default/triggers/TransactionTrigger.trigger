/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 08-29-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   08-29-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
trigger TransactionTrigger on Transaction__c(after insert, after delete, after update, after undelete) {
	TransactionHelper.updateEvents();
	TransactionHelper.postChatterDebts();
}
