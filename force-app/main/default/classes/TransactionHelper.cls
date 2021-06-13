/**
 * @File Name          : TransactionHelper.cls
 * @Description        :
 * @Author             : Luis Campos (lucam75@gmail.com)
 * @Group              :
 * @Last Modified By   : Luis Campos (LC)
 * @Last Modified On   : 06-13-2021
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    1/8/2020   Luis Campos (lucam75@gmail.com)     Initial Version
 **/
public with sharing class TransactionHelper {
	public static void updateEvents() {
		List<Event__c> eventsToUpdate = TransactionHelper.getEventsToUpdate();

		if (!eventsToUpdate.isEmpty() && Event__c.SObjectType.getDescribe().isUpdateable()) {
			update eventsToUpdate;
		}
	}

	public static void postChatterDebts() {
		if (Trigger.isAfter && Trigger.isInsert) {
			for (Transaction__c trx : [SELECT Id, Billed_to__r.User__r.Id, Paid_By__r.User__r.Id, Paid_By__r.Name, Amount__c, Description__c FROM Transaction__c WHERE It_is_debt__c = TRUE AND Id IN :Trigger.newMap.keySet() WITH SECURITY_ENFORCED]) {
				TransactionHelper.getFeedItemDebts(trx);
			}
		}
	}

	private static List<Event__c> getEventsToUpdate() {
		List<Transaction__c> transactions = Trigger.isDelete ? Trigger.old : Trigger.new;
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

	private static void getFeedItemDebts(Transaction__c trx) {
		if (trx.Billed_to__r != null && trx.Billed_to__r.User__r != null && trx.Paid_By__r != null && trx.Paid_By__r.User__r != null) {
			ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
			ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
			ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
			ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();

			messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

			mentionSegmentInput.id = trx.Billed_to__r.User__r.Id;
			messageBodyInput.messageSegments.add(mentionSegmentInput);

			textSegmentInput.text = ', ' + trx.Paid_By__r.Name + ' just created this transaction billed to you for ' + trx.Amount__c + ' corresponding to ' + trx.Description__c;
			messageBodyInput.messageSegments.add(textSegmentInput);

			feedItemInput.body = messageBodyInput;
			feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
			feedItemInput.subjectId = trx.Id;

			ConnectApi.ChatterFeeds.postFeedElement(null, feedItemInput);
		}
	}
}
