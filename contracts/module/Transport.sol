// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "node_modules/hardhat/console.sol";

interface Transportation {
    function run() external returns (uint8);
}

interface TransportationError {
    error TransportationInsufficientGas(uint8 needed, uint8 available);
}

abstract contract AbstractTransportation is Transportation, TransportationError {

    string internal sourceLocation;
    string internal destinationLocation;
    uint8 internal distance;
    enum Status {Arrive, OnTheWay, Yet}

    function addDistance(uint8 addDistanceValue) internal {
        distance += addDistanceValue;
    }

}

abstract contract WithEngine {}

contract Motorcycle is AbstractTransportation {


    address internal immutable owner;

    constructor() {
        owner = msg.sender;
    }

    uint8 constant internal STEP_COUNT = 5;


    function run() override external returns (uint8){
//        gas -= STEP_COUNT;
        addDistance(STEP_COUNT);
        return AbstractTransportation.distance;
    }


}