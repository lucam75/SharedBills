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

    @wire(getRecord, { recordId: '$UserId', fields: FIELDS })
    user;

    constructor(){
        super();
        console.log('CreateSharedExpense');
        this.amount = 100;
        this.paidBy = this.user;
        this.billedTo = this.user;
        console.log('user ' + this.user);
    }
    handleSuccess(){
        alert('success');
    }
}