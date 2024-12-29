// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
call in combination with re-entrancy guard is the recommended method to use after December 2019.

Guard against re-entrancy by
 - making all state changes before calling other contracts
 - using re-entrancy guard modifier
*/

contract ReceiveEther {
    /*
    Which function is called, fallback() or receive()?

           send Ether
               |
         msg.data is empty?
              / \
            yes  no
            /     \
    receive() exists?  fallback()
         /   \
        yes   no
        /      \
    receive()   fallback()
    */

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract SendEther {
    function sendViaTransfer(address payable _to) public payable {
        // This function is no longer recommended for sending Ether.
        _to.transfer(msg.value);
    }

    function sendViaSend(address payable _to) public payable {
        // Send returns a boolean value indicating success or failure.
        // This function is not recommended for sending Ether.
        bool sent = _to.send(msg.value);
        require(sent, "Failed to send Ether");
    }

    function sendViaCall(address payable _to) public payable {
        // Call returns a boolean value indicating success or failure.
        // This is the current recommended method to use.
        (bool sent, bytes memory data) = _to.call{value: msg.value, gas: 2300}("");
        require(sent, "Failed to send Ether");
    }
}

/*
transfer、send、call 默认发送的是当前合约的以太币，可以给函数增加 payable 关键词，然后使用 msg.value 发送函数调用者的以太币
*/

