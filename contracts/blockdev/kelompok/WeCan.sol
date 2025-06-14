// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {DonationInstance} from "./DonationInstance.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {DonationMaker} from "./DonationMaker.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Pausable} from "@openzeppelin/contracts/security/Pausable.sol";

contract WeCan is ERC20, AccessControl, Pausable, DonationMaker {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    constructor() ERC20("WeCan Token", "WCAN") {
        ERC20._mint(_msgSender(), type(uint256).max);
        AccessControl._setupRole(ADMIN_ROLE, _msgSender());
    }

    /*============= Pausable =============*/
    function pause() public onlyRole(ADMIN_ROLE) whenNotPaused {
        super._pause();
    }

    function unpause() public onlyRole(ADMIN_ROLE) whenPaused {
        super._unpause();
    }

    /*============= ERC20 =============*/
    // Hanya bisa transfer ketika not paused
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {

        // Do After
        super._afterTokenTransfer(from, to, amount);

        // Cek Pelimpahan jika address tujuan adalah instance donation
        if (isAddressDonationInstance[to]) {
            DonationInstance instance = DonationInstance(to);
            if (
                // Jika target dicapai, maka limpahkan
                ERC20.balanceOf(to) > instance.amountTarget() ||
                // Jika expired, maka limpahkan
                instance.expiredAt() < block.timestamp
            ) {
                // Limpahkan
                ERC20._transfer(to, instance.receiver(), ERC20.balanceOf(to));
                emit PelimpahanEvent(to, ERC20.balanceOf(to), block.timestamp);
            }
        }
    }

    /*============= Donation Maker =============*/
    function createDonation(
        string memory title,
        string memory description,
        address receiver,
        uint256 amountTarget,
        uint256 duration
    ) public
    override
    requireNotDonationAddress(receiver)
    returns (bool) {
        return
            super.createDonation(
            title,
            description,
            receiver,
            amountTarget,
            duration
        );
    }

    function getCollectedDonation(address donationAddress)
    public
    view
    override
    requireDonationAddress(donationAddress)
    returns (uint256)
    {
        return super.balanceOf(donationAddress);
    }

    event PelimpahanEvent(
        address donationInstance,
        uint256 amount,
        uint256 timestamp
    );
}

