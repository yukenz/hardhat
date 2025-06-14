// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {DonationInstance} from "./WeCan.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {Pausable} from "@openzeppelin/contracts/security/Pausable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

abstract contract DonationMaker {
    // Maker -> Donation Instance
    mapping(address => address[]) public donationCreatedList;

    // Donation Address
    mapping(address => bool) public isAddressDonationInstance;

    // DonationInstance Address Valid
    modifier donationAddressValid(address donationAddress) {
        require(
            isAddressDonationInstance[donationAddress],
            "Address is not donation contract"
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
    ) public override returns (bool) {
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
    donationAddressValid(donationAddress)
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
