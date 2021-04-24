import { createElement } from "lwc";
import CreateSharedExpense from "c/createSharedExpense";

describe("c-create-shared-expense", () => {
	afterEach(() => {
		// The jsdom instance is shared across test cases in a single file so reset the DOM
		while (document.body.firstChild) {
			document.body.removeChild(document.body.firstChild);
		}
	});

	it("First Step Screen", () => {
		const element = createElement("c-create-shared-expense", {
			is: CreateSharedExpense
		});
		document.body.appendChild(element);

		const step1Div = element.shadowRoot.querySelector("div[data-id=step1Div]div.show");
		const step2Div = element.shadowRoot.querySelector("div[data-id=step2Div]div.hidden");
		const step3Div = element.shadowRoot.querySelector("div[data-id=step3Div]div.hidden");

		const mainTitle = step1Div.querySelector("h3.title");
		const inputFields = step1Div.querySelectorAll("lightning-input-field");
		const radioGroup = step1Div.querySelectorAll("lightning-radio-group");
		const checkboxGroup = step1Div.querySelectorAll("lightning-checkbox-group");
		const buttons = step1Div.querySelectorAll("lightning-button");

		expect(step1Div).not.toBeNull();
		expect(step2Div).not.toBeNull();
		expect(step3Div).not.toBeNull();

		expect(mainTitle.textContent).toBe("Main Information");

		expect(inputFields).not.toBe(null);
		expect(inputFields.length).toBe(1);
		expect(radioGroup).not.toBe(null);
		expect(radioGroup.length).toBe(1);
		expect(checkboxGroup).not.toBe(null);
		expect(checkboxGroup.length).toBe(1);

		expect(buttons).not.toBeNull();
		expect(buttons.length).toBe(2);

		expect(buttons[0].label).toBe("Extended Shared Bill");
		expect(buttons[1].label).toBe("Next");
	});

	it("Second Step Screen", () => {
		const element = createElement("c-create-shared-expense", {
			is: CreateSharedExpense
		});
		document.body.appendChild(element);

		//const nextButton = element.shadowRoot.querySelectorAll("div[data-id=step1Div]div.show lightning-button[name=next]");
		element.shadowRoot.querySelector("lightning-button[data-id=next]").click();

		const step1Div = element.shadowRoot.querySelector("div[data-id=step1Div]div.hidden");
		const step2Div = element.shadowRoot.querySelector("div[data-id=step2Div]div.show");
		const step3Div = element.shadowRoot.querySelector("div[data-id=step3Div]div.hidden");

		const mainTitle = step2Div.querySelector("h3.title");

		expect(step1Div).not.toBeNull();
		expect(step2Div).not.toBeNull();
		expect(step3Div).not.toBeNull();

		expect(mainTitle.textContent).toBe("Additional Details");
	});
});
