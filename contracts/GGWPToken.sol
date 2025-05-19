// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract GGWPToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("Good Game Will Play", "GGWP") {
        _mint(msg.sender, initialSupply);
    }
}