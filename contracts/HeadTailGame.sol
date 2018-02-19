pragma solidity ^0.4.17;

contract HeadTailGame {

    address public head;
    address public tail;
    address public dealer;

    function HeadTailGame() public {
        // Dealer create game
        dealer = msg.sender;
    }

    function enterHead() public payable {
        // Head must be empty
        require(head == address(0));

        // Minimal value
        require(msg.value > 0.01 ether);

        head = msg.sender;
    }

    function enterTail() public payable {
        // Head must be empty
        require(tail == address(0));

        // Minimal value
        require(msg.value > 0.01 ether);

        tail = msg.sender;
    }

    function pickWinner() public restricted {
        // Players exist
        require(head != address(0));
        require(tail != address(0));

        if (randomBool()) {
            head.transfer(this.balance);
        } else {
            tail.transfer(this.balance);
        }
    }

    modifier restricted() {
        require(msg.sender == dealer);
        _;
    }

    function randomBool() private view returns (bool) {
        return bool(uint(keccak256(block.difficulty, now, head, tail)) % 2 != 0);
    }

}