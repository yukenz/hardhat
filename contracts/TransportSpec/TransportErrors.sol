// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface TransportErrors {

    /**
    @dev Mengindikasikan bahan bakar yang kurang
    @param needed Bahan bakar yang dibutuhkan
    @param available Bahan bakar yang tersisa
    */
    error TransportInsufficientGas(uint256 needed, uint256 available);

}