// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Immutable {
    address payable public owner;
    constructor() {
        owner = payable(msg.sender);
    }

    function deposit() public payable {}

    function noDeposit() public {}

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function withdraw() public {
        uint amount = address(this).balance;
        owner.transfer(amount);
        assert (address(this).balance == 0);
    }


}