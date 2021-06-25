public with sharing class CurrentStatusUtils {
	@AuraEnabled
	public static List<AggregateResult> getBills(String yearMonth) {
		List<AggregateResult> data = new List<AggregateResult>();
		if (String.isNotBlank(yearMonth)) {
			List<String> separated = yearMonth.split('-');
			data = [SELECT SUM(Amount__c), Paid_By__r.Name Paidby, Paid_By__r.Email PaidByEmail, Billed_to__r.Name BilledTo FROM Transaction__c WHERE CALENDAR_MONTH(Date__c) = :Integer.valueOf(separated.get(1)) AND CALENDAR_YEAR(Date__c) = :Integer.valueOf(separated.get(0)) AND It_is_debt__c = TRUE WITH SECURITY_ENFORCED GROUP BY Billed_to__r.Name, Paid_By__r.Name, Paid_By__r.Email];
		}

		return data;
	}
}
