// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface TravelMetadata {

    function sourceLocation() external view returns (string memory);
    function destinationLocation() external view returns (string memory);
    function distance() external view returns (uint8);
    function progress() external view returns (uint8);

}