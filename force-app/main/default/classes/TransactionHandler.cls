/**
 * @author Luis Campos
 * @date 3/26/2018
 * @description
 *
 * Before Insert: -
 *
 */
public with sharing class TransactionHandler implements ITrigger {
	List<Event__c> eventsToUpdate = new List<Event__c>();

	public TransactionHandler() {
	}

	/**
	 * bulkBefore
	 *
	 * Extended from ITrigger.  This method is called prior to execution of a
	 * BEFORE trigger. Use this to cache any data required into maps prior
	 * execution of the trigger.
	 */
	public void bulkBefore() {
	}
	/**
	 * bulkAfter
	 *
	 * Extended from ITrigger.  This method is called prior to execution of a
	 * AFTER trigger. Use this to cache any data required into maps prior
	 * execution of the trigger.
	 */
	public void bulkAfter() {
		if (Trigger.isDelete) {
			eventsToUpdate = TransactionHelper.calculateAmountPerEvent(Trigger.old);
		} else {
			eventsToUpdate = TransactionHelper.calculateAmountPerEvent(Trigger.new);
		}
	}

	public void beforeInsert(SObject so) {
	}

	public void beforeUpdate(SObject oldSo, SObject so) {
	}

	public void beforeDelete(SObject so) {
	}
	/**
	 * afterInsert
	 *
	 * Extended from ITrigger.  This is invoke by the TriggerFactory who iterates
	 * on each record triggered.  Here we apply the logic to determine if any DML
	 * operation must be excuted.  If the User.ProfileId is 'Partner Staff' then
	 * we must insert a new groupMember record for that User.
	 *
	 * @param so: Is the User record sent by TriggerFactory, this came as an SObject *
	 */
	public void afterInsert(SObject so) {
	}
	/**
	 * afterUpdate
	 *
	 * Extended from ITrigger.  This is invoke by the TriggerFactory who iterates
	 * on each record triggered.  Here we apply the logic to determine if any DML
	 * operation must be excuted.  If the User.ProfileId changes to 'Partner Staff' then
	 * we must insert a new groupMember record for that User.
	 *
	 * @param so: Is the User record sent by TriggerFactory, this came as an SObject *
	 */
	public void afterUpdate(SObject oldSo, SObject so) {
	}
	/**
	 * afterDelete
	 *
	 * Extended from ITrigger.  This is invoke by the TriggerFactory who iterates
	 * on each record triggered.  Here we apply the logic to determine if any DML
	 * operation must be excuted.  If the User.ProfileId is 'Partner Staff' then
	 * we must delete the groupMember record associated to that User.
	 *
	 * @param so: Is the User record sent by TriggerFactory, this came as an SObject *
	 */
	public void afterDelete(SObject so) {
	}

	/**
	 * andFinally
	 *
	 * This method is called once all records have been processed by the trigger. Use this
	 * method to accomplish any final operations such as creation or updates of other records.
	 */
	public void andFinally() {
		//if(trigger.isAfter) BackgroundCheckRequestHandler.firstRun=false;
		if (!eventsToUpdate.isEmpty()) {
			update eventsToUpdate;
		}
	}
}
