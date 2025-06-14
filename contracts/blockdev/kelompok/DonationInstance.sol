// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract DonationInstance {
    string public title;
    string public description;
    address public receiver;
    uint256 public amountTarget;
    uint256 public expiredAt;

    // Constructor
    constructor(
        string memory _title,
        string memory _description,
        address _receiver,
        uint256 _amountTarget,
        uint256 _expiredAt
    ) {
        title = _title;
        description = _description;
        receiver = _receiver;
        amountTarget = _amountTarget;
        expiredAt = _expiredAt;
    }
}
