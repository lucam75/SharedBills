import { LightningElement, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import UserId from '@salesforce/user/Id';

const FIELDS = [
    'User.Id',
    'User.Name',
];

export default class CreateSharedExpense extends NavigationMixin(LightningElement) {

    @track amount;
    @track paidBy;
    @track billedTo;
    @track currentStep;

    amountForDiana;

    @wire(getRecord, { recordId: '$UserId', fields: FIELDS })
    user;

    constructor(){
        super();
        console.log('CreateSharedExpense');
        this.paidBy = this.user;
        //this.billedTo = this.user;
        //console.log('user ' + this.user);
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
    get halfAccount() {
        return this.amount / 2;
    }
    handleSuccess(){
        alert('success');
    }
    get comms() {
        return [{ label: "Ross", value: "Option1" }, { label: "Rachel", value: "Option2" }];
    }        
    handleSelected(e) {
        this.billedTo = e.detail.value;
    }
    nextStep(){
        this.currentStep++;
    }
    prevStep(){
        this.currentStep--;
    }
}