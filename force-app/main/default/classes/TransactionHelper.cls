/**
 * @File Name          : TransactionHelper.cls
 * @Description        :
 * @Author             : Luis Campos (lucam75@gmail.com)
 * @Group              :
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 08-29-2020
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    1/8/2020   Luis Campos (lucam75@gmail.com)     Initial Version
 **/
public with sharing class TransactionHelper {
	public static void updateEvents() {
		List<Event__c> eventsToUpdate;

		if (Trigger.isDelete) {
			eventsToUpdate = TransactionHelper.getEventsToUpdate(Trigger.old);
		} else {
			eventsToUpdate = TransactionHelper.getEventsToUpdate(Trigger.new);
		}

		if (!eventsToUpdate.isEmpty() && Event__c.SObjectType.getDescribe().isUpdateable()) {
			update eventsToUpdate;
		}
	}

	private static List<Event__c> getEventsToUpdate(List<Transaction__c> transactions) {
		List<Event__c> eventsToUpdate = new List<Event__c>();

		if (transactions != null && transactions.size() > 0) {
			Set<Id> eventIds = new Set<Id>();

			for (Transaction__c record : transactions) {
				eventIds.add(record.Event__c);
			}

			if (!eventIds.isEmpty()) {
				for (AggregateResult ar : [SELECT Event__c, SUM(Amount__c) FROM Transaction__c WHERE Event__c IN :eventIds AND Event__c != '' WITH SECURITY_ENFORCED GROUP BY Event__c]) {
					eventsToUpdate.add(new Event__c(Id = (Id) ar.get('Event__c'), Total_spent__c = (Double) ar.get('expr0')));
				}
			}
		}

		return eventsToUpdate;
	}
}
