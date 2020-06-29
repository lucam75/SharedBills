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
	@track currentStep = 1;
	@track billedToSelected = [''];
	@track category;
	@track date;
	@track account;
	@track event;
	@track description;
	@track billedToSelectedList = [];

	@api notifyViaAlerts = false;
	@track errors = [];

	createdTransactionsIds = [];
	showSliders = true;
	@track manualMode = false;

	@wire(getAllContacts)
	contacts;

	connectedCallback(){
		// Set Date to Today
		const now = new Date();
		const offsetMs = now.getTimezoneOffset() * 60 * 1000;
		const dateLocal = new Date(now.getTime() - offsetMs);
		this.date = dateLocal.toISOString().slice(0, 19).replace(/-/g, "-").replace("T", " ");

		getLoggedContact()
			.then(result => {
				this.paidBy = result.Id;
			})
			.catch(error => {
				console.error(error);
			});
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

	get contactsOptions() {
		let contactsOptions = [];
		if(this.contacts.data !== undefined){
			this.contacts.data.forEach(val => {
				contactsOptions.push({ 'label': val.Name, 'value': val.Id });
			});
		}
		return contactsOptions;
	}

	// Handle field updates
	handleBilledSelectedChange(e) {
		this.billedToSelected = e.detail.value;
		this.showSliders = this.billedToSelected.length > 1
		this.updateBilledToSelectedList();
	}
	handlePaidBySelected(e){
		this.paidBy = e.detail.value;
	}
	handleAmountChange(e) {
		this.amount = e.detail.value;
	}
	handleDateChange(e) {
		this.date = e.detail.value;
	}
	handleDescriptionChange(e) {
		this.description = e.detail.value;
	}
	handleSliderChange(event) {
		let sliderContactId = event.target.dataset.item;
		let sliderContactAmount = event.detail.value;
		this.billedToSelectedList.find(x => x.key === sliderContactId).value.amount = sliderContactAmount;

		let calculatedNewAmount = (this.amount - sliderContactAmount) / (this.billedToSelectedList.length - 1);

		this.billedToSelectedList.forEach(contact => {
			if (contact.key != sliderContactId ) {
				contact.value.amount = calculatedNewAmount;
			}
		});
	}
	handleManualAmountChange(event) {
		let sliderContactId = event.target.dataset.item;
		let sliderContactAmount = event.detail.value;
		this.billedToSelectedList.find(x => x.key === sliderContactId).value.amount = sliderContactAmount;
	}
	handleCreateExpense(){
		console.log('handleCreateExpense');

		console.log('this.billedToSelectedList.length ', this.billedToSelectedList.length);
		if(this.billedToSelectedList.length > 1 ){
			this.billedToSelectedList.forEach(contact => {
				this.createSingleTransaction(contact.key, contact.value.amount);
			});
		}else if (this.billedToSelectedList.length == 1) {
			this.createSingleTransaction(this.billedToSelectedList[0].key, this.billedToSelectedList[0].amount);
		}else {
			this.notifyUser('Error', 'Please select at least one contact to create the bill.', 'error');
		}
		
	}
	handleLookupSearch(event) {
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

	handleLookupSelectionChange(event) {
		const lookupType = event.target.getkey();
		const itemSelected = event.target.getSelection();
		// [{"icon":"custom:custom46","id":"a003j00000TkrGJAAZ","sObjectType":"Category","subtitle":"","title":"Comida vegana"}]

		if(lookupType == 'category_lookup'){
			this.category = itemSelected[0];
		}else if(lookupType == 'account_lookup'){
			this.account = itemSelected[0];
		}else if(lookupType == 'event_lookup'){
			this.event = itemSelected[0];
		}
	}

	handleManualModeChange(event) {
		console.log('handleManualModeChange ');
		this.manualMode = event.target.checked;
	}

	// Navigation events
	nextStep(){
		this.currentStep++;
		if(this.currentStep === 3){
			this.step3Logic();
		}
	}
	prevStep(){
		this.currentStep--;
		if (this.currentStep === 2) {
			if (this.category != null) {
				let category_lookup = this.template.querySelectorAll('category_lookup');
				console.log(JSON.stringify(category_lookup));
				category_lookup.selection = this.category;
			}
		}
	}

	// Utilitary methods
	getContactLabel(contactId){
		if(this.contacts.data !== undefined && contactId !== ''){
			return this.contacts.data.find(contact => contact.Id === contactId).Name;
		}
		return '';
	}

	step3Logic(){
		this.showSliders = true;
	}

	updateBilledToSelectedList() {
		console.log('updateBilledToSelectedList ');
		let tempBilledToSelectedList = [];
		this.billedToSelected.forEach(billed => {
			let added = { key: billed, value: { 'label': this.getContactLabel(billed), 'contactId': billed, 'amount' : this.dividedAmount }};
            tempBilledToSelectedList.push(added);
		});

		this.billedToSelectedList = tempBilledToSelectedList;		
	}

	createSingleTransaction(billedTo, amount){
		console.log('createSingleTransaction');
		const fields = {};
		fields[AMOUNT_FIELD.fieldApiName] = amount;
		fields[BILLED_TO_FIELD.fieldApiName] = billedTo;
		fields[CATEGORY_FIELD.fieldApiName] = this.category.id;
		fields[DATE_FIELD.fieldApiName] = this.date;
		fields[EVENT_FIELD.fieldApiName] = this.event != undefined ? this.event.id : '';
		fields[PAID_BY_FIELD.fieldApiName] = this.paidBy;
		fields[DESCRIPTION_FIELD.fieldApiName] = this.description;
		fields[ACCOUNT_FIELD.fieldApiName] = this.account != undefined ? this.account.id : '';

		const recordInput = { apiName: TRANSACTION_OBJECT.objectApiName, fields };
		console.log('recordInput ', recordInput);
		/*createRecord(recordInput)
			.then(transaction => {
				this.createdTransactionsIds.push(transaction.id);
				this.notifyUser('Success', 'Shared transaction created', 'success');
			})
			.catch(error => {
				console.log(JSON.stringify(error));
				this.notifyUser('Error creating shared transaction', error.body.message, 'error');
			});*/
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