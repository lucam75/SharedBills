/**
 * @File Name          : StatusController.cls
 * @Description        : 
 * @Author             : Luis Campos (LC)
 * @Group              : 
 * @Last Modified By   : Luis Campos (lucam75@gmail.com)
 * @Last Modified On   : 11/1/2019, 5:23:00 PM
 * @Modification Log   : 
 * Ver       Date            Author                 Modification
 * 1.0    10/28/2019   Luis Campos (LC)     Initial Version
**/
public with sharing class StatusController {
    public Decimal deudaDiana {get;set;}
    public Decimal deudaLuis {get;set;}
    public String deudor {get;set;}
    public String cobrador {get;set;}
    public String deudaDianaString {get;set;}
    public String deudaLuisString {get;set;}
    public String totalDebtAmountString {get;set;}
    public String emailDiana {get;set;}
    public String emailLuis {get;set;}

    public statusController() {
        try{
            this.deudaLuis = 0;
            this.deudaDiana = 0;
            this.deudor = '';
            this.cobrador = '';
            this.deudaDianaString = '';
            this.deudaLuisString = '';
            this.totalDebtAmountString = '';
            this.emailDiana = '';
            this.emailLuis = '';
            
            if (Schema.sObjectType.Transaction__c.isQueryable()) {
                for(AggregateResult ar : [SELECT SUM(Amount__c), Paid_By__r.Name Paidby, Paid_By__r.Email PaidByEmail, Billed_to__r.Name BilledTo FROM Transaction__c WHERE Date__c = THIS_MONTH and It_is_debt__c = true GROUP BY Billed_to__r.Name, Paid_By__r.Name, Paid_By__r.Email]){
                    if(ar != null){
                        if(ar.get('Paidby') == 'Diana Gonzalez'){
                            this.deudaLuis = (Decimal)ar.get('expr0');
                            this.emailDiana = (string)ar.get('PaidByEmail');
                        }else if(ar.get('Paidby') == 'Luis Campos'){
                            this.deudaDiana = (Decimal)ar.get('expr0');
                             this.emailLuis = (string)ar.get('PaidByEmail');
                        }
                    }
                }

                setDeudor();
            }else{
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'You don\'t have permission to read the Transaction Object.');
                ApexPages.addMessage(msg);
            }
        }catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, e.getMessage());
            ApexPages.addMessage(msg);
        }
    }

    private Void setDeudor(){
            if(this.deudaLuis > this.deudaDiana){
                this.deudor = 'Luis';
                this.cobrador = 'Diana';
            }else{
                this.deudor = 'Diana';
                this.cobrador = 'Luis';
            }

            setLabels();
    }

    private Void setLabels(){
        this.deudaDianaString = this.amountToDisplay(this.deudaDiana);
        this.deudaLuisString = this.amountToDisplay(this.deudaLuis);
        if(this.deudaDiana > this.deudaLuis){
            totalDebtAmountString = this.amountToDisplay(this.deudaDiana - this.deudaLuis);
        }else {
            totalDebtAmountString = this.amountToDisplay(this.deudaLuis - this.deudaDiana);
        }
    }

    private String amountToDisplay(Decimal amount){
        Decimal pesos;
        Decimal cents;
        pesos = amount.intValue();
        cents = amount - amount.intValue();
        cents = cents.setScale(2);
        return '$' + pesos.format() + cents.toPlainString().substring(1);
    }
}