// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Basic {

    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

}
