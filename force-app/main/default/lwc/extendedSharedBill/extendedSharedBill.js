import { LightningElement, track, api } from "lwc";

const columns = [
	{ label: "Billed to", fieldName: "contactName", editable: false, cellAttributes: { class: "slds-p-around_none" } },
	{ label: "Amount", fieldName: "amount", type: "currency", editable: true, cellAttributes: { class: "slds-p-around_none" } },
	{ type: "button-icon", typeAttributes: { iconName: "utility:delete", name: "delete", iconClass: "slds-icon-text-error" }, fixedWidth: 30 }
];

export default class ExtendedSharedBill extends LightningElement {
	@api contacts;
	@track currentItem = {};
	@track itemsList = [];

	columns = columns;
	key = 0;

	setCurrentItemAmount(e) {
		this.currentItem.amount = e.detail.value;
	}

	addItem(e) {
		if (e.target.value !== undefined && e.target.value !== "" && !isNaN(this.currentItem.amount)) {
			this.currentItem.billedTo = e.target.value;
			this.itemsList = [...this.itemsList, { key: this.key++, contactName: this.getContactLabel(this.currentItem.billedTo), billedTo: this.currentItem.billedTo, amount: parseFloat(this.currentItem.amount) }];
			this.currentItem = {};
		} else {
			console.log("No added to list ");
		}
		this.template.querySelector('[data-id="currentItemAmount"]').focus();
	}

	handleDone(e) {
		this.dispatchEvent(new CustomEvent("extendedsbdone", { detail: this.itemsList }));
	}

	handleBack(e) {
		this.dispatchEvent(new CustomEvent("extendedsbback", {}));
	}

	handleSave(e) {
		let tempList = this.itemsList;
		e.detail.draftValues.slice().forEach((valueChanged) => {
			valueChanged.key = valueChanged.key === "row-0" ? 0 : valueChanged.key; // IDK why return row-0 for the first row
			let index = tempList.findIndex((item) => item.key === parseInt(valueChanged.key, 10));
			if (index !== -1) {
				tempList[index].amount = parseFloat(valueChanged.amount);
			}
		});
		this.itemsList = [...tempList];
	}

	handleDelete(event) {
		let tempList = this.itemsList;
		let index = this.itemsList.findIndex((item) => item.key === parseInt(event.detail.row.key, 10));
		if (index !== -1) {
			tempList.splice(index, 1);
			this.itemsList = [...tempList];
		}
	}

	getContactLabel(contactId) {
		if (this.contacts !== undefined && contactId !== "" && contactId !== "Shared") {
			return this.contacts.find((contact) => contact.value === contactId).label;
		}
		return contactId;
	}
	get areAddedItems() {
		return this.itemsList.length > 0;
	}
}
