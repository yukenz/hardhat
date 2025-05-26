// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface Transport {

    event Run(uint8 step);

    function run(uint8 step) external returns (uint256 usedGas);

}