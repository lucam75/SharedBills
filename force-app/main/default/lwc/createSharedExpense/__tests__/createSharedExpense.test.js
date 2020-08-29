import { createElement } from "lwc";
import CreateSharedExpense from "c/createSharedExpense";

describe("c-create-shared-expense", () => {
	afterEach(() => {
		// The jsdom instance is shared across test cases in a single file so reset the DOM
		while (document.body.firstChild) {
			document.body.removeChild(document.body.firstChild);
		}
	});

	it("Mount LWC", () => {
		const element = createElement("c-create-shared-expense", {
			is: CreateSharedExpense
		});
		document.body.appendChild(element);
		const mainTitle = element.shadowRoot.querySelector("h3.title");
		const step1InputFields = element.shadowRoot.querySelectorAll("lightning-input-field");
		expect(mainTitle.textContent).toBe("Main Information");
		expect(step1InputFields).not.toBe(null);
		expect(step1InputFields.length).toBe(3);
	});
});
