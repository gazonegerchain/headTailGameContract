const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const web3 = new Web3(ganache.provider());
const { interface, bytecode } = require('../compile');

let accounts;

beforeEach(async () => {
  	// Get a list of all accounts
  	accounts = await web3.eth.getAccounts();

  	// Use one of those accounts to deploy the contract
  	game = await new web3.eth.Contract(JSON.parse(interface))
    	.deploy({ data: bytecode })
    	.send({ from: accounts[0], gas: '1000000' });
});

describe('Inbox', () => {
	it('deploys a contract', () => {
    	assert.ok(game.options.address);
  	});
	
  	it('insufficient balance', () => {
		try {
			game.methods.enterHead().send({
				from: accounts[1],
				value: web3.utils.toWei('0.005', 'ether')
			});
			assert(false);
		} catch(err) {
			assert(err);
		}
	});
	
	it('player should be unique', () => {
		game.methods.enterHead().send({
				from: accounts[1],
				value: web3.utils.toWei('1', 'ether')
		});
		try {
			game.methods.enterHead().send({
				from: accounts[1],
				value: web3.utils.toWei('1', 'ether')
			});
			
			assert(false);
		} catch(err) {
			assert(err);
		}
	});
    
    it("dealer can't play game", () => {
        try {
			game.methods.enterHead().send({
				from: accounts[0],
				value: web3.utils.toWei('1', 'ether')
			});
			assert(false);
		} catch(err) {
			assert(err);
		}
    });
});