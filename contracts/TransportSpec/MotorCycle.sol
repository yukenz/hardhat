// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Engine} from "./Engine.sol";
import {Transport} from "./Transport.sol";
import {Context} from "@openzeppelin/contracts/utils/Context.sol";


contract MotorCycle is Context, Engine, Transport {

    address public rider;
    uint8 public constant RUN_PRICE = 100;

    constructor() {
        rider = _msgSender();
    }

    function run(uint8 step) external returns (uint256){
        uint256 usedGas = step * RUN_PRICE;
        useGas(usedGas);
        emit Run(step);
        return usedGas;
    }

    function fillGas() external payable returns (bool) {
        address filler = _msgSender();
        uint256 value = uint(msg.value);

        Engine.fillGas(filler, value);

        return true;
    }

}