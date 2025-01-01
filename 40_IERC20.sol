// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
Any contract that follow the ERC20 standard is a ERC20 token.
ERC20 tokens provide functionalities to
- transfer tokens
- allow others to transfer tokens on behalf of the token holder
Here is the interface for ERC20.
*/

interface IERC20 {
    // 返回代币的总供应量。
    function totalSupply() external view returns (uint256);
    // 查询指定地址的代币余额。
    function balanceOf(address account) external view returns (uint256);
    // 将代币从调用者地址转移到另一个地址。
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
    // 查询授权地址能从某个地址转移的代币数量。
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);
    // 授权指定地址可以使用调用者的代币。
    function approve(address spender, uint256 amount) external returns (bool);
    // 从一个地址转移代币到另一个地址（前提是调用者已被授权）。
    function transferFrom(address sender, address recipient, uint256 amount)
        external
        returns (bool);
}
