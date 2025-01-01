// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract PiggyBank {
    event Withdraw(uint _amount, address _addr);
    event Receive(uint _amount, address _addr);
    address public owner = msg.sender;

    receive() external payable {
        emit Receive(msg.value, msg.sender);
    }

    function withdraw() external {
        require(msg.sender == owner, "not owner");
        emit Withdraw(address(this).balance , msg.sender);
        selfdestruct(payable(msg.sender));
    }
}