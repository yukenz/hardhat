// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.28;

contract HelloWorld {

    function helloWorld() public view returns (string memory) {
        string memory hw = "Hello World";
        return hw;
    }

}