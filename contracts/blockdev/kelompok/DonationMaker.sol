// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {DonationInstance} from "./DonationInstance.sol";


abstract contract DonationMaker {
    // Maker -> Donation Instance
    mapping(address => address[]) public donationCreatedList;

    // Donation Address
    mapping(address => bool) public isAddressDonationInstance;

    // DonationInstance Address Valid
    modifier requireDonationAddress(address donationAddress) {
        require(
            isAddressDonationInstance[donationAddress],
            "Address is not donation contract"
        );
        _;
    }

    modifier requireNotDonationAddress(address donationAddress) {
        require(
            !isAddressDonationInstance[donationAddress],
            "Address is donation contract"
        );
        _;
    }

    // Get Amount of Donation Instance
    function getCollectedDonation(address donationAddress)
    public
    view
    virtual
    returns (uint256);

    // Create Donation
    event CreateDonationEvent(
        string title,
        address indexed creator,
        address indexed receiver,
        uint256 amountTarget,
        uint256 duration
    );

    function createDonation(
        string memory title,
        string memory description,
        address receiver,
        uint256 amountTarget,
        uint256 duration
    ) public virtual returns (bool) {
        DonationInstance donationInstance = new DonationInstance(
            title,
            description,
            receiver,
            amountTarget,
            block.timestamp + duration
        );

        // Register Maker -> Donation Instance
        donationCreatedList[msg.sender].push(address(donationInstance));
        // Register Address -> Is Donation Instance
        isAddressDonationInstance[address(donationInstance)] = true;

        emit CreateDonationEvent({
            title: title,
            creator: msg.sender,
            receiver: receiver,
            amountTarget: amountTarget,
            duration: duration
        });

        return true;
    }

}
