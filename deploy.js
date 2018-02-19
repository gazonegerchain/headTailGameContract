const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');

const { interface, bytecode } = require('./compile');

const provider = new HDWalletProvider(
		'guitar radio expect evoke appear raise join ice unhappy bracket unfold fuel',
		'https://rinkeby.infura.io/KPuGcSf24ZoItW4lldgx'
);

const web3 = new Web3(provider);

const deploy = async () => {
	const accounts = await web3.eth.getAccounts();

	console.log('Attempting to deploy from accout ', accouts[0]);

	const result = await new web3.eht.Contract(JSON.parse(interface))
		.deploy({ data: bytecode})
		.send({ gas: '1000000', from: accouts[0] });

	console.log('Contract deployed to ', result.options.address);
};

deploy();