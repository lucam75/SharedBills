import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';


export default class CreateSharedExpense extends NavigationMixin(LightningElement) {

    getAmount(){
        console.log('getAmount');
        return 100;
    }
    handleSuccess(){
        alert('success');
    }
}