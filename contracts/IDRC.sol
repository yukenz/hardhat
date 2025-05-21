// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract IDRC is ERC20 {
    constructor() ERC20("Indonesia Rupiah", "IDRC") {
        _mint(msg.sender, 2**256 - 1);
    }
}