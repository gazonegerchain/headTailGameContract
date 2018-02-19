pragma solidity ^0.4.17;

contract HeadTailGame {

	uint8 fee = 1;

	struct Player {
		address account;
		uint deposit;
	}

    Player public head;
    Player public tail;
    address public dealer;
    
    function HeadTailGame() public {
        // Dealer create game
        dealer = msg.sender;
    }

	function returnChange() private {
		if (tail.deposit > head.deposit) {
			tail.account.transfer(tail.deposit - head.deposit);
		} else {
			head.account.transfer(head.deposit - tail.deposit);
		}
	}

    function enterHead() public notDealer payable {
        // Head must be empty
        require(head.account == address(0));

        // Minimal value
        require(msg.value > 0.01 ether);

        head.account = msg.sender;
		head.deposit = msg.value;
    }

    function enterTail() public notDealer payable {
        // Head must be empty
        require(tail.account == address(0));

        // Minimal value
        require(msg.value > 0.01 ether);

        tail.account = msg.sender;
		tail.deposit = msg.value;
    }
	
	modifier notDealer() {
		require(msg.sender != dealer);
		_;
	}

    function pickWinner() public restricted {
        // Players exist
        require(head.account != address(0));
        require(tail.account != address(0));

		returnChange();

	    // Payment to the winner
        if (randomBool()) {
            head.account.transfer(this.balance * (100 - fee) / 100);
        } else {
            tail.account.transfer(this.balance * (100 - fee) / 100);
        }

	    // Dealer fee
	    dealer.transfer(this.balance);
	
        // Reset players
		head = Player(address(0), 0);
		tail = Player(address(0), 0);
    }

    modifier restricted() {
        require(msg.sender == dealer);
        _;
    }

    function randomBool() private view returns (bool) {
        return bool(uint(keccak256(block.difficulty, now,
					head.account, tail.account)) % 2 != 0);
    }

}
