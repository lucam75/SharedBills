<script>
	import { onMount } from 'svelte';
	// props
	export let getBills;

	let bills = [];
	let selectedYearMonth;

	let debtor;
	let debtCollector;
	let debt = 0;

	// Functions

	let askForData = event => {
		getBills({yearMonth: selectedYearMonth})
		.then(result => {
			bills = result;
			debtCalculation();
		})
		.catch(error => console.error(error))
	}

	onMount(async () => {

		let now = new Date(), month, day, year;
		month = '' + (now.getMonth() + 1),
		day = '' + now.getDate(),
		year = now.getFullYear();

		if (month.length < 2) {
			month = '0' + month;
		}
			
		selectedYearMonth = [year, month].join('-');
		if (typeof(getBills) === 'function') {
			const tempBills = await getBills({yearMonth: selectedYearMonth});
			bills = await tempBills;
			debtCalculation();
		}
	});

	let debtCalculation = () => {
		if (bills.length > 1) {
			let maxDebt = bills.reduce((p, c) => p.expr0 > c.expr0 ? p : c);
			let minDebt = bills.reduce((p, c) => p.expr0 < c.expr0 ? p : c);
			debtor = minDebt.Paidby;
			debtCollector = maxDebt.Paidby;
			debt = maxDebt.expr0 - minDebt.expr0;
		} else {
			debtor = bills[0].BilledTo;
			debtCollector = bills[0].Paidby;
			debt = bills[0].expr0;
		}
	}

	let formatMoney = (amount, decimalCount = 2, decimal = ".", thousands = ",") => {
		try {
			const currencySign = '$';
			decimalCount = Math.abs(decimalCount);
			decimalCount = isNaN(decimalCount) ? 2 : decimalCount;

			const negativeSign = amount < 0 ? "-" : "";

			let i = parseInt(amount = Math.abs(Number(amount) || 0).toFixed(decimalCount)).toString();
			let j = (i.length > 3) ? i.length % 3 : 0;

			return currencySign + negativeSign + (j ? i.substr(0, j) + thousands : '') + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + thousands) + (decimalCount ? decimal + Math.abs(amount - i).toFixed(decimalCount).slice(2) : "");
		} catch (e) {
			console.log(e)
		}
	};
</script>

<main>
	<h1>Status for month: {selectedYearMonth}</h1>
	<input type="month" id="month" name="month" bind:value={selectedYearMonth} on:change={askForData} />

	{#if debtor !== undefined && debtCollector !== undefined}
	<div class="debt-summary">
		<strong>{debtor}</strong> le debe a <strong>{debtCollector}</strong> la cantidad de <span class="money">{formatMoney(debt, 2, ",", ".")}</span>
	</div>
	{/if}

	{#if bills.length > 0}
	<div class="debt-container">
		<div class="debt-info">
			{#each bills as { expr0, Paidby, BilledTo }, i}
				<div class="debt-info-item">
					<div class="column">
						<strong>{BilledTo}</strong> le debe a <strong>{Paidby}</strong> la cantidad de 
					</div>
					<div class="column">
						<span class="money align-right">{formatMoney(expr0, 2, ",", ".")}</span>
					</div>
				</div>
			{/each}
		</div>
	</div>
	{/if}
</main>

<style>
	main {
		text-align: center;
		margin: 0 auto;
		padding: var(--lwc-varSpacingVerticalMedium,1rem) var(--lwc-varSpacingHorizontalMedium,1rem);
		border-bottom: var(--lwc-borderWidthThin,1px) solid var(--lwc-pageHeaderColorBorder,rgb(221, 219, 218));
		border-radius: var(--lwc-pageHeaderBorderRadius,0.25rem);
		background: var(--lwc-pageHeaderColorBackground,rgb(243, 242, 242));
		background-clip: padding-box;
		box-shadow: var(--lwc-pageHeaderShadow,0 2px 2px 0 rgba(0, 0, 0, 0.10));
		border: var(--lwc-borderWidthThin,1px) solid var(--lwc-pageHeaderColorBorder,rgb(221, 219, 218));
	}

	main h1 {
		font-size: 2rem;
	}

	main .debt-container {
		padding-top: 30px;
		display: flex;
    	justify-content: center;
	}

	main .debt-info {
		background-color: white;
		border-radius: 10px;
		padding: 10px;
		
	}

	main .debt-info .debt-info-item {
		width: 100%;
		display: flex;
		flex-direction: row;
		justify-content: space-between;
		padding: 8px;
	}

	main .debt-info .debt-info-item .column {
		margin-right: 10px;
	}

	main .debt-summary {
		padding-top: 30px;
		font-size: large;
	}

	main span.money {
		color: #ff3e00;
	}

	main .align-right {
		text-align: right;
	}
</style>