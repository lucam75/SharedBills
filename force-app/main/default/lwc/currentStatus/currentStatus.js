import { LightningElement } from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
// import getContacts from '@salesforce/apex/SvelteController.getContacts';
// import updateContactToPizza from '@salesforce/apex/SvelteController.updateContactToPizza';

// import Svelte static resource
import svelteApp from '@salesforce/resourceUrl/Svelte';


export default class CurrentStatus extends LightningElement {
	hasInitialRender = false;

	renderedCallback() {
	  if(this.hasInitialRender) {
		return;
	  }
	  this.hasInitialRender = true;
  
	  Promise.all([
		loadScript(this, svelteApp + '/bundle.js'),
		loadStyle(this, svelteApp + '/bundle.css')
	  ])
	  .then(() => {
		mount(this.template.querySelector('div[data-id="app"]'), {});
	  })
	  .catch(error => console.error(error))
	}
  }