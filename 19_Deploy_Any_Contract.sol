// SPDX-License-Identifier: MIT

/*
Deploy any contract by calling Proxy.deploy(bytes memory _code)

For this example, you can get the contract bytecodes by calling Helper.getBytecode1 and Helper.getBytecode2.
*/

pragma solidity ^0.8.26;

contract Proxy {
    event Deploy(address);

    receive() external payable {}

    function deploy(bytes memory _code)
        external
        payable
        returns (address addr)
    {
        assembly {
            // create(v, p, n)
            // v = amount of ETH to send
            // p = pointer in memory to start of code
            // n = size of code
            addr := create(callvalue(), add(_code, 0x20), mload(_code))
        }
        // return address 0 on error
        require(addr != address(0), "deploy failed");

        emit Deploy(addr);
    }

    function execute(address _target, bytes memory _data) external payable {
        (bool success,) = _target.call{value: msg.value}(_data);
        require(success, "failed");
    }
}

contract TestContract1 {
    address public owner = msg.sender;

    function setOwner(address _owner) public {
        require(msg.sender == owner, "not owner");
        owner = _owner;
    }
}

contract TestContract2 {
    address public owner = msg.sender;
    uint256 public value = msg.value;
    uint256 public x;
    uint256 public y;

    constructor(uint256 _x, uint256 _y) payable {
        x = _x;
        y = _y;
    }
}

contract Helper {
    function getBytecode1() external pure returns (bytes memory) {
        bytes memory bytecode = type(TestContract1).creationCode;
        return bytecode;
    }

    function getBytecode2(uint256 _x, uint256 _y)
        external
        pure
        returns (bytes memory)
    {
        bytes memory bytecode = type(TestContract2).creationCode;
        return abi.encodePacked(bytecode, abi.encode(_x, _y));
    }

    function getCalldata(address _owner) external pure returns (bytes memory) {
        return abi.encodeWithSignature("setOwner(address)", _owner);
    }
}

/*
 1. Helper.getBytecode1() 获取合约的 code
 2. Proxy.depoly(code) 获取 TestContract1 合约部署的 address
 3. 选择 TestContract1 合约后，使用 At Address(address) 启动合约，此时 TestContract1 合约的 owner 为 Proxy 合约
 4. Helper.getCalldata(newOwner) 获取 setOwner 的 data
 5. Proxy.execute(address, data) 执行配置 owner 的操作
*/