/**
 * @File Name          : TransactionHelper.cls
 * @Description        :
 * @Author             : Luis Campos (lucam75@gmail.com)
 * @Group              :
 * @Last Modified By   : Luis Campos (lucam75@gmail.com)
 * @Last Modified On   : 1/8/2020, 7:38:16 PM
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    1/8/2020   Luis Campos (lucam75@gmail.com)     Initial Version
 **/
public class TransactionHelper {
	public static List<Event__c> calculateAmountPerEvent(List<Transaction__c> transactions) {
		List<Event__c> eventsToUpdate = new List<Event__c>();
		try {
			if (transactions != null && transactions.size() > 0) {
				Set<Id> eventIds = new Set<Id>();

				for (Transaction__c record : transactions) {
					eventIds.add(record.Event__c);
				}

				if (!eventIds.isEmpty()) {
					for (AggregateResult ar : [SELECT Event__c, SUM(Amount__c) FROM Transaction__c WHERE Event__c IN :eventIds AND Event__c != '' GROUP BY Event__c]) {
						eventsToUpdate.add(new Event__c(Id = (Id) ar.get('Event__c'), Total_spent__c = (Double) ar.get('expr0')));
					}
				}
			}
		} catch (Exception e) {
		}

		return eventsToUpdate;
	}
}
