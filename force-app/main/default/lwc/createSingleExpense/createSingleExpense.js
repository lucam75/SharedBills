import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class CreateSingleExpense extends LightningElement {

    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: "Transaction created",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(evt);
    }
}