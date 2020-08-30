import { LightningElement } from "lwc";
import { loadScript, loadStyle } from "lightning/platformResourceLoader";
import getBills from "@salesforce/apex/CurrentStatusUtils.getBills";
// import updateContactToPizza from '@salesforce/apex/SvelteController.updateContactToPizza';

// import CurrentStatusSvelte static resource
import currentStatusSvelte from "@salesforce/resourceUrl/CurrentStatusSvelte";

export default class CurrentStatus extends LightningElement {
	hasInitialRender = false;

	renderedCallback() {
		if (this.hasInitialRender) {
			return;
		}
		this.hasInitialRender = true;

		Promise.all([loadScript(this, currentStatusSvelte + "/bundle.js"), loadStyle(this, currentStatusSvelte + "/bundle.css")])
			.then(() => {
				// eslint-disable-next-line no-undef
				mount(this.template.querySelector('div[data-id="app"]'), {
					getBills
				});
			})
			.catch((error) => console.log("lwc error", JSON.stringify(error)));
	}
}
