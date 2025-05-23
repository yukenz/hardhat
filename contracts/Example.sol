// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "node_modules/hardhat/console.sol";

contract Basic {

    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

}
