<script>
	import { onMount } from 'svelte';
	// props
	export let getBills;

	let bills = [];
	let now = new Date();
	let selectedMonth = now.getMonth() + 1;
	let selectedYear = now.getFullYear();
	let selectedYearMonth = selectedYear + '-' + selectedMonth;

	let debtor;
	let debtCollector;
	let debt = 0;

	onMount(() => {
		console.log('onMount');
	});

	// Functions

	let askForData = event => {
		getBills({yearMonth: selectedYearMonth})
		.then(result => {
			bills = result;

			console.log(JSON.stringify(bills));
			debtCalculation();
		})
		.catch(error => console.error(error))
	}

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

	<div class="debt-information">
		<table>
			{#each bills as { expr0, Paidby, BilledTo }, i}
				<tr>
					<td><strong>{BilledTo}</strong></td>
					<td>le debe a </td>
					<td><strong>{Paidby}</strong></td>
					<td>la cantidad de </td>
					<td class="align-right"><span class="money">{formatMoney(expr0, 2, ",", ".")}</span></td>
				</tr>
			{/each}
		</table>
	</div>
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

	main .debt-information {
		padding-top: 30px;
	}

	main .debt-information table {
		width: 40%;
		margin: 0 auto;
		background-color: white;
		border-radius: 10px;
		padding: 10px;
	}

	main .debt-information table td{
		padding: 15px;
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