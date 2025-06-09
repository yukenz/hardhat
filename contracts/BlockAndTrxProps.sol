// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @dev Properties yang terdapat pada Block dan Transaction.
 * See https://docs.soliditylang.org/en/v0.8.30/units-and-global-variables.html#special-variables-and-functions
 * Originally based on code by Yukenz: https://github.com/yukenz
 */
contract BlockAndTrxProps {

    /**
     * @dev Properties yang tersedia di msg, kecuali value (karna hanya bisa didapat lewat payable).
     */
    function getMsgInfo()
    public
    view
    returns (
        bytes calldata msgData,
        address msgSender,
        bytes4 msgSig
    )
    {
        msgData = msg.data;
        msgSender = msg.sender;
        msgSig = msg.sig;
    }

    /**
     * @dev Block Hash yang tersedia pada block yang telah terbuat.
     */
    function getBlockInfo(uint256 blockNumber)
    public
    view
    returns (
        bytes32 blockHashInfo //1
//        bytes32 blobHashInfo //2
    )
    {
        blockHashInfo = blockhash(blockNumber);
//        blobHashInfo = blobhash(blockNumber);
    }

    /**
     * @dev Properties yang tersedia pada block yang dibuat sekarang oleh VM.
    */
    function getCurrentBlockInfo()
    public
    view
    returns (
        uint256 blockBaseFeeInfo, //1
//        uint256 blobBaseFeeInfo, //2
        uint256 blockChainIdInfo, //3
        address blockMinerAddress, //4
        uint256 blockDifficultyInfo, //5
        uint256 blockGasLimitInfo, //6
        uint256 blockTimestamp, //8
        uint256 gasLeftInfo, //9
        uint256 gasPriceValue, //10
        address originValue //11
    )
    {
        blockBaseFeeInfo = block.basefee;
//        blobBaseFeeInfo = block.blobbasefee; // HardHat Error
        blockChainIdInfo = block.chainid;
        blockMinerAddress = block.coinbase;
        // blockDifficultyInfo =  block.difficulty; | < paris
        blockDifficultyInfo = block.prevrandao; // >= paris
        blockGasLimitInfo = block.gaslimit;
        blockTimestamp = block.timestamp;
        gasLeftInfo = gasleft();
        gasPriceValue = tx.gasprice;
        originValue = tx.origin;
    }

    /**
     * @dev Properties yang tersedia pada block yang dibuat sekarang oleh VM.
     */
    function testTransactionMetadata()
    external
    payable
    returns (
        bytes calldata msgData,  //1
        address msgSender,  //2
        bytes4 msgSig,  //3
        uint256 msgValue,  //4
        uint256 gasLeftInfo,  //5
        address originValue //6
    )
    {
        msgData = msg.data;
        msgSender = msg.sender;
        msgSig = msg.sig;
        msgValue = msg.value;
        gasLeftInfo = gasleft();
        originValue = tx.origin;
    }
}
