/**
 * @File Name          : StatusController.cls
 * @Description        :
 * @Author             : Luis Campos (LC)
 * @Group              :
 * @Last Modified By   : Luis Campos (lucam75@gmail.com)
 * @Last Modified On   : 11/1/2019, 5:23:00 PM
 * @Modification Log   :
 * Ver       Date          Author			Modification
 * 1.0    10/28/2019   Luis Campos (LC)     Initial Version
 * 1.1    08/08/2020   Luis Campos (LC)     Refactoring and limiting scope
 **/
public with sharing class StatusController {
	private Decimal deudaDiana { get; set; }
	private Decimal deudaLuis { get; set; }
	private String debtor { get; set; }
	private String debtCollector { get; set; }
	private String deudaDianaString { get; set; }
	private String deudaLuisString { get; set; }
	private String totalDebtFormmated { get; set; }
	private String emailDiana { get; set; }
	private String emailLuis { get; set; }

	public statusController() {
		this.deudaLuis = 0;
		this.deudaDiana = 0;
		this.debtor = '';
		this.debtCollector = '';
		this.deudaDianaString = '';
		this.deudaLuisString = '';
		this.totalDebtFormmated = '';
		this.emailDiana = '';
		this.emailLuis = '';

		for (AggregateResult ar : [SELECT SUM(Amount__c), Paid_By__r.Name Paidby, Paid_By__r.Email PaidByEmail, Billed_to__r.Name BilledTo FROM Transaction__c WHERE Date__c = LAST_MONTH AND It_is_debt__c = TRUE WITH SECURITY_ENFORCED GROUP BY Billed_to__r.Name, Paid_By__r.Name, Paid_By__r.Email]) {
			if (ar != null) {
				if (ar.get('Paidby') == 'Diana Gonzalez') {
					this.deudaLuis = (Decimal) ar.get('expr0');
					this.emailDiana = (string) ar.get('PaidByEmail');
				} else if (ar.get('Paidby') == 'Luis Campos') {
					this.deudaDiana = (Decimal) ar.get('expr0');
					this.emailLuis = (string) ar.get('PaidByEmail');
				}
			}
		}

		setDeptor();
		setLabels();
	}

	private Void setDeptor() {
		if (this.deudaLuis > this.deudaDiana) {
			this.debtor = 'Luis';
			this.debtCollector = 'Diana';
		} else {
			this.debtor = 'Diana';
			this.debtCollector = 'Luis';
		}
	}

	private Void setLabels() {
		this.deudaDianaString = formatAmount(this.deudaDiana);
		this.deudaLuisString = formatAmount(this.deudaLuis);
		if (this.deudaDiana > this.deudaLuis) {
			totalDebtFormmated = formatAmount(this.deudaDiana - this.deudaLuis);
		} else {
			totalDebtFormmated = formatAmount(this.deudaLuis - this.deudaDiana);
		}
	}

	private String formatAmount(Decimal amount) {
		Decimal pesos;
		Decimal cents;
		pesos = amount.intValue();
		cents = amount - amount.intValue();
		cents = cents.setScale(2);
		return '$' + pesos.format() + cents.toPlainString().substring(1);
	}

	public String getDebtor() {
		return this.debtor;
	}

	public String getDebtCollector() {
		return this.debtCollector;
	}

	public string getTotalDebtFormatted() {
		return this.totalDebtFormmated;
	}

	public List<String> getContactsEmail() {
		return new List<String>{ this.emailLuis, this.emailDiana };
	}
}
