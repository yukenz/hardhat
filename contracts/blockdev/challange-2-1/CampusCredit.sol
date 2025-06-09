// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

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
// TODO: Define role constants
// bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
// bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

// Additional features untuk kampus
    mapping(address => uint256) public dailySpendingLimit;
    mapping(address => uint256) public spentToday;
    mapping(address => uint256) public lastSpendingReset;

// Merchant whitelist
    mapping(address => bool) public isMerchant;
    mapping(address => string) public merchantName;

    constructor() ERC20("Campus Credit", "CREDIT") {
// TODO: Setup roles
// Hint:
// 1. Grant DEFAULT_ADMIN_ROLE ke msg.sender
// 2. Grant PAUSER_ROLE ke msg.sender
// 3. Grant MINTER_ROLE ke msg.sender
// 4. Consider initial mint untuk treasury
    }

/**
 * @dev Pause all token transfers
     * Use case: Emergency atau maintenance
     */
    function pause() public {
// TODO: Implement dengan role check
// Only PAUSER_ROLE can pause
    }

    function unpause() public {
// TODO: Implement unpause
    }

/**
 * @dev Mint new tokens
     * Use case: Top-up saldo mahasiswa
     */
    function mint(address to, uint256 amount) public {
// TODO: Implement dengan role check
// Only MINTER_ROLE can mint
// Consider adding minting limits
    }

/**
 * @dev Register merchant
     * Use case: Kafetaria, toko buku, laundry
     */
    function registerMerchant(address merchant, string memory name)
    public onlyRole(DEFAULT_ADMIN_ROLE)
    {
// TODO: Register merchant untuk accept payments
    }

/**
 * @dev Set daily spending limit untuk mahasiswa
     * Use case: Parental control atau self-control
     */
    function setDailyLimit(address student, uint256 limit)
    public onlyRole(DEFAULT_ADMIN_ROLE)
    {
// TODO: Set spending limit
    }

/**
 * @dev Transfer dengan spending limit check
     */
    function transferWithLimit(address to, uint256 amount) public {
// TODO: Check daily limit before transfer
// Reset limit if new day
// Update spent amount
// Then do normal transfer
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
// super._beforeTokenTransfer(from, to, amount);
// require(!paused(), "Token transfers paused");
    }

/**
 * @dev Cashback mechanism untuk encourage usage
     */
    uint256 public cashbackPercentage = 2; // 2%

    function transferWithCashback(address merchant, uint256 amount) public {
// TODO: Transfer to merchant dengan cashback ke sender
// Calculate cashback
// Transfer main amount
// Mint cashback to sender
    }
}