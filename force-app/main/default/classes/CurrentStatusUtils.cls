public with sharing class CurrentStatusUtils {
	@AuraEnabled
	public static List<AggregateResult> getBills(String yearMonth) {
		List<AggregateResult> data = new List<AggregateResult>();
		if (String.isNotBlank(yearMonth)) {
			List<String> separated = yearMonth.split('-');
			Integer year = Integer.valueOf(separated.get(0));
			Integer month = Integer.valueOf(separated.get(1));

			if (Schema.sObjectType.Transaction__c.isQueryable()) {
				String query = 'SELECT SUM(Amount__c), Paid_By__r.Name Paidby, Paid_By__r.Email PaidByEmail, Billed_to__r.Name BilledTo FROM Transaction__c WHERE CALENDAR_MONTH(Date__c) = :month and CALENDAR_YEAR(Date__c) = :year and It_is_debt__c = true GROUP BY Billed_to__r.Name, Paid_By__r.Name, Paid_By__r.Email';
				data = Database.query(query);
			}
		}

		return data;
	}
}
