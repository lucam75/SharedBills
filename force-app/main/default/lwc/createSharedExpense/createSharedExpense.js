import { LightningElement, track, wire, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import getAllContacts from '@salesforce/apex/CreateSharedExpenseHelper.getAllContacts';
import getLoggedContact from '@salesforce/apex/CreateSharedExpenseHelper.getLoggedContact';
import apexSearch from '@salesforce/apex/CreateSharedExpenseHelper.search';


import TRANSACTION_OBJECT from '@salesforce/schema/Transaction__c';
import AMOUNT_FIELD from '@salesforce/schema/Transaction__c.Amount__c';
import BILLED_TO_FIELD from '@salesforce/schema/Transaction__c.Billed_to__c';
import CATEGORY_FIELD from '@salesforce/schema/Transaction__c.Category__c';
import DATE_FIELD from '@salesforce/schema/Transaction__c.Date__c';
import EVENT_FIELD from '@salesforce/schema/Transaction__c.Event__c';
import PAID_BY_FIELD from '@salesforce/schema/Transaction__c.Paid_By__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Transaction__c.Description__c';
import ACCOUNT_FIELD from '@salesforce/schema/Transaction__c.Account__c';

export default class CreateSharedExpense extends NavigationMixin(LightningElement) {

    @track amount;
    @track paidBy;
    @track currentStep;
    @track billedToSelected = [''];
    @track category;
    @track date;
    @track account;
    @track event;
    @track description;

    billedToAmounts = {};
    createdTransactionsIds = [];

    @wire(getAllContacts)
    contacts;

    connectedCallback(){
        getLoggedContact()
            .then(result => {
                this.paidBy = result.Id;
            })
            .catch(error => {
                /*eslint no-console: "error"*/
                console.error(error);
            });
        this.currentStep = 1;
    }

    get renderStep1() {
        return this.currentStep === 1;
    }
    get renderStep2() {
        return this.currentStep === 2;
    }
    get renderStep3() {
        return this.currentStep === 3;
    }
    get dividedAmount() {
        return this.amount / this.billedToSelected.length;
    }
    handleSuccess(){
        alert('success');
    }
    handleSelected(e) {
        this.billedToSelected = e.detail.value;
    }
    handlePaidBySelected(e){
        this.paidBy = e.detail.value;
    }
    updateTrackedAmount(e) {
        this.amount = e.detail.value;
    }
    
    updateTrackedDate(e) {
        this.date = e.detail.value;
    }

    updateTrackedDescription(e) {
        this.description = e.detail.value;
    }
    contactLabel(contactId){
        if(this.contacts.data !== undefined && contactId !== ''){
            return this.contacts.data.find(contact => contact.Id === contactId).Name;
        }
        return '';
    }
    get billedToSelectedList(){
        let billeds = [];
        this.billedToSelected.forEach(billed => {
            billeds.push({ 'label': this.contactLabel(billed), 'value': billed });
        });
        return billeds;
    }
    get contactsOptions() {
        let contactsOptions = [];
        if(this.contacts.data !== undefined){
            this.contacts.data.forEach(val => {
                contactsOptions.push({ 'label': val.Name, 'value': val.Id });
            });
        }
        return contactsOptions;
    }
    nextStep(){
        this.currentStep++;
        if(this.currentStep === 3){
            this.Step3DefaultValues();
        }
    }
    prevStep(){
        this.currentStep--;
    }
    handleSliderChange(event) {
        let index = event.target.dataset.item;
        let value = event.detail.value;
        this.billedToAmounts[index] = value;
    }
    Step3DefaultValues(){
        this.billedToAmounts = {};
        this.billedToSelected.forEach(contact => {
            this.billedToAmounts[contact] = this.dividedAmount;
        });
    }

    handleCreateExpense(){
        console.log('handleCreateExpense');

        for(let contact in this.billedToAmounts) {
            if (Object.prototype.hasOwnProperty.call(this.billedToAmounts, contact)) {
                let amount = this.billedToAmounts[contact];
                this.createSingleTransaction(amount, contact);
            }
        }
    }

    createSingleTransaction(amount, billedTo){
        const fields = {};
        fields[AMOUNT_FIELD.fieldApiName] = amount;
        fields[BILLED_TO_FIELD.fieldApiName] = billedTo;
        fields[CATEGORY_FIELD.fieldApiName] = this.category;
        fields[DATE_FIELD.fieldApiName] = this.date;
        fields[EVENT_FIELD.fieldApiName] = this.event;
        fields[PAID_BY_FIELD.fieldApiName] = this.paidBy;
        fields[DESCRIPTION_FIELD.fieldApiName] = this.description;
        fields[ACCOUNT_FIELD.fieldApiName] = this.account;

        const recordInput = { apiName: TRANSACTION_OBJECT.objectApiName, fields };
        createRecord(recordInput)
            .then(transaction => {
                this.createdTransactionsIds.push(transaction.id);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Shared transaction created',
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                console.log(JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating shared transaction',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }

    @api notifyViaAlerts = false;

    @track errors = [];

    handleSearch(event) {
        let lookupType = event.target.getkey();
        let parameters = event.detail;
        
        parameters.lookupType = lookupType;
        const target = event.target;

        apexSearch(parameters)
            .then(results => {
                target.setSearchResults(results);
            })
            .catch(error => {
                this.notifyUser(
                    'Lookup Error',
                    'An error occured while searching with the lookup field.',
                    'error'
                );
                // eslint-disable-next-line no-console
                console.error('Lookup error', JSON.stringify(error));
                this.errors = [error];
            });
    }

    handleSelectionChange(event) {
        let lookupType = event.target.getkey();
        const itemSelected = event.target.getSelection();
        // [{"icon":"custom:custom46","id":"a003j00000TkrGJAAZ","sObjectType":"Category","subtitle":"","title":"Comida vegana"}]
        if(lookupType == 'category_lookup'){
            this.category = itemSelected.id;
        }else if(lookupType == 'account_lookup'){
            this.account = itemSelected.id;
        }else if(lookupType == 'event_lookup'){
            this.event = itemSelected.id;
        }
    }

    notifyUser(title, message, variant) {
        if (this.notifyViaAlerts) {
            // Notify via alert
            // eslint-disable-next-line no-alert
            alert(`${title}\n${message}`);
        } else {
            // Notify via toast
            const toastEvent = new ShowToastEvent({ title, message, variant });
            this.dispatchEvent(toastEvent);
        }
    }
}