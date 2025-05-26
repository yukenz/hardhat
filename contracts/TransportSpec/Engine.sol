// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


abstract contract Engine {

    error TransportInsufficientGas(uint256 needed, uint256 available);

    event FillGas(address filler, uint256 amount);

    function fillGas(address filler, uint256 amount) internal virtual returns (bool) {
        emit FillGas(filler, amount);
        return true;
    }

    function useGas(uint256 value) internal returns (bool) {
        uint256 contractBalance = address(this).balance;

        if (contractBalance < value) {
            revert TransportInsufficientGas(value, contractBalance);
        }

        payable(0x0).transfer(value);
        return true;
    }

}