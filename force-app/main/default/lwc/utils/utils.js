const dianaId = '0033j00003CIp8LAAT';
const luisId = '0033j00003CIp7hAAD';
const predefinedValues = {
	arriendo : {
		amount: 360000,
		category: {icon:"custom:custom46", id:"a003j00000Tvb9xAAB", sObjectType:"Category", subtitle:"", title:"Arriendo"},
		account: {icon:"standard:account", id:"0013j00002bCPLOAA4", sObjectType:"Category", subtitle:"", title:"Rexner"},
		event: [],
		description: 'Pago arriendo',
		paidBy: dianaId,
		billedTo: [dianaId, luisId]
	},
};

export { predefinedValues };