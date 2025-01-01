// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract AccessControl {
    event GrandRole(bytes32 indexed _role, address indexed _account);
    event RevokeRole(bytes32 indexed _role, address indexed _account);

    mapping(bytes32 => mapping(address => bool)) public roles;

    bytes32 private constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
    // 0xdf8b4c520ffe197c5343c6f5aec59570151ef9a492f2c624fd45ddde6135ec42
    bytes32 private constant USER = keccak256(abi.encodePacked("USER"));
    // 0x2db9fd3d099848027c2383d0a083396f6c41510d7acfd92adc99b6cffcf31e96


    constructor () {
        _grantRole(ADMIN, msg.sender);
    }

    function _grantRole(bytes32 _role, address _account) private {
        roles[_role][_account] = true;
        emit GrandRole(_role, _account);
    }

    modifier onlyRole(bytes32 _role) {
        require(roles[_role][msg.sender], "not authorized");
        _;
    }

    function grantRole(bytes32 _role, address _account) public onlyRole(ADMIN) {
        _grantRole(_role, _account);
    }

    function revokeRole(bytes32 _role, address _account) public onlyRole(ADMIN) {
        roles[_role][_account] = false;
        emit RevokeRole(_role, _account);
    }
}