// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {MotorCycle} from "./TransportSpec/MotorCycle.sol";
import {TravelMetadata} from "./TransportSpec/TravelMetadata.sol";
import {Context} from "@openzeppelin/contracts/utils/Context.sol";


contract TravelWithMotor is Context, TravelMetadata {

    address public person;
    MotorCycle public motorcycle;

    string private sourceLocationValue;
    string private destinationLocationValue;
    uint8 private distanceValue;
    uint8 private progressValue;

    constructor(
        string memory sourceLocationInput,
        string memory destinationLocationInput,
        uint8 distanceInput
    ) payable {

        person = _msgSender();
        motorcycle = new MotorCycle();

        sourceLocationValue = sourceLocationInput;
        destinationLocationValue = destinationLocationInput;
        distanceValue = distanceInput;
        progressValue = 0;
    }

    function motorAddreess() public view returns (address){
        return address(motorcycle);
    }

    function buyGas(uint256 value) public payable returns (bool) {
        motorcycle.fillGas{value:value}();
        return true;
    }

    function run(uint8 step) public returns (uint256){
        return motorcycle.run(step);
    }

    function sourceLocation() external view returns (string memory){
        return sourceLocationValue;
    }

    function destinationLocation() external view returns (string memory){
        return destinationLocationValue;
    }

    function distance() external view returns (uint8){
        return distanceValue;
    }

    function progress() external view returns (uint8){
        return progressValue;
    }

}
