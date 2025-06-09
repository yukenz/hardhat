// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

interface DigitalWalletKampusError {
    error InsufficientBalance(uint256 balanceAvailable);
}

contract DigitalWalletKampus is Context, DigitalWalletKampusError {
    mapping(address => uint256) public balances;
    address public admin;

    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);

    constructor() {
        admin = msg.sender;
    }

    function deposit() public payable {
        require(msg.value > 0, "Amount harus lebih dari 0");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

// TODO: Implementasikan withdraw function

    function withdraw(address toAddr, uint256 amount) public approve(amount) {

        balances[_msgSender()] -= amount;

        emit Withdrawal(toAddr, amount);
    }

// TODO: Implementasikan transfer function

    function transfer(address toAddr, uint256 amount) public approve(amount) {

        balances[_msgSender()] -= amount;
        balances[toAddr] += amount;

        emit Transfer(_msgSender(), toAddr, amount);
    }

// TODO: Tambahkan access control
    modifier approve(uint256 amount)  {
        require(balances[_msgSender()] >= amount, InsufficientBalance(balances[_msgSender()]));
        _;
    }

}