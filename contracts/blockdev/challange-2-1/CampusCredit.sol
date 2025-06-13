// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {Pausable} from "@openzeppelin/contracts/security/Pausable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "node_modules/hardhat/console.sol";

//import {AccessControl} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.6/contracts/access/AccessControl.sol";
//import {Pausable} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.6/contracts/security/Pausable.sol";
//import {ERC20} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.6/contracts/token/ERC20/ERC20.sol";
//import {ERC20Burnable} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.6/contracts/token/ERC20/extensions/ERC20Burnable.sol";
//import {SafeMath} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.6/contracts/utils/math/SafeMath.sol";

/**
* @title CampusCredit
* @dev ERC-20 token untuk transaksi dalam kampus
 * Use cases:
 * - Pembayaran di kafetaria
 * - Biaya printing dan fotokopi
 * - Laundry service
 * - Peminjaman equipment
 */
contract CampusCredit is ERC20, ERC20Burnable, Pausable, AccessControl {

    using SafeMath for uint256;

    // TODO: Define role constants
    bytes32 public constant PAUSER_ROLE = keccak256(abi.encodePacked("PAUSER_ROLE"));
    bytes32 public constant MINTER_ROLE = keccak256(abi.encodePacked("MINTER_ROLE"));

    // Additional features untuk kampus
    mapping(address => uint256) public dailySpendingLimit;
    mapping(address => uint256) public spentToday;
    mapping(address => uint256) public lastSpendingReset;

    // Merchant whitelist
    mapping(address => bool) public isMerchant;
    mapping(address => string) public merchantName;

    constructor() ERC20("Campus Credit", "CREDIT") {
        // TODO: Grant DEFAULT_ADMIN_ROLE ke msg.sender
        AccessControl._setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        // TODO: Grant PAUSER_ROLE ke msg.sender
        AccessControl._setupRole(PAUSER_ROLE, msg.sender);
        // TODO: Grant MINTER_ROLE ke msg.sender
        AccessControl._setupRole(MINTER_ROLE, msg.sender);
        // TODO: Consider initial mint untuk treasury
        ERC20._mint(msg.sender, type(uint256).max / 4);
        dailySpendingLimit[msg.sender] = type(uint256).max;
        lastSpendingReset[msg.sender] = type(uint256).max;
    }

    /**
     * @dev Pause all token transfers
     * Use case: Emergency atau maintenance
     */
    function pause()
    public
        // TODO: Implement dengan role check
        // Only PAUSER_ROLE can pause
    onlyRole(PAUSER_ROLE) {
        Pausable._pause();
    }

    function unpause()
    public
        // TODO: Implement unpause
    onlyRole(PAUSER_ROLE)
    {
        Pausable._unpause();
    }

    /**
     * @dev Mint new tokens
     * Use case: Top-up saldo mahasiswa
     */
    function mint(address to, uint256 amount)
    public
        // TODO: Implement dengan role check
        // Only MINTER_ROLE can mint
    onlyRole(MINTER_ROLE)
    {
        // Consider adding minting limits
        require(amount < (type(uint256).max / 300), "Only 1/300 of max supply once minting");
        ERC20._mint(to, amount);
    }

    /**
     * @dev Register merchant
     * Use case: Kafetaria, toko buku, laundry
     */
    function registerMerchant(address merchant, string memory name)
    public
    onlyRole(DEFAULT_ADMIN_ROLE)
    {
        // TODO: Register merchant untuk accept payments
        merchantName[merchant] = name;
        isMerchant[merchant] = true; // Hanay register, mempertahankan state banned
    }

    /**
     * @dev Set daily spending limit untuk mahasiswa
     * Use case: Parental control atau self-control
     */
    function setDailyLimit(address student, uint256 limit)
    public onlyRole(DEFAULT_ADMIN_ROLE)
    {
        // TODO: Set spending limit
        dailySpendingLimit[student] = limit;
    }

    /**
     * @dev Transfer dengan spending limit check
     */
    function transferWithLimit(address to, uint256 amount) public {

        // TODO: Check daily limit before transfer
        require(spentToday[msg.sender] + amount < dailySpendingLimit[msg.sender], "Daily Limit Triggered");

        // TODO: Reset limit if new day
        // Jika waktu reset adalah kosong, maka init
        if (lastSpendingReset[msg.sender] == 0) {
            unchecked{
                lastSpendingReset[msg.sender] = block.timestamp + 24 hours;
            }
        }

        // Jika waktu reset kurang dari sekarang, maka majukan
        if (lastSpendingReset[msg.sender] < block.timestamp) {
            unchecked{
                lastSpendingReset[msg.sender] = block.timestamp + 24 hours;
            }
        }

        // TODO: Update spent amount
        unchecked{
            spentToday[msg.sender] += amount;
        }

        // TODO: Then do normal transfer
        ERC20.transfer(to, amount);
    }

    /**
     * @dev Override _beforeTokenTransfer untuk add pause functionality
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20) {
        // TODO: Add pause check
        ERC20._beforeTokenTransfer(from, to, amount);
        require(!Pausable.paused(), "Token transfers paused");
    }

    /**
     * @dev Cashback mechanism untuk encourage usage
     */
    uint256 public cashbackPercentage = 2;  // 2%

    function transferWithCashback(address merchant, uint256 amount) public {

        require(isMerchant[merchant], "Merchant tidak ada");

        // TODO: Transfer to merchant dengan cashback ke sender
        // Calculate cashback

        uint percent = cashbackPercentage.mul(100);
        uint scale = uint256(100).mul(100);
        uint256 cashback = (amount * percent) / scale;

        // Transfer main amount
        transferWithLimit(merchant, amount);

        // Mint cashback to sender
        ERC20._mint(msg.sender, cashback);
    }
}