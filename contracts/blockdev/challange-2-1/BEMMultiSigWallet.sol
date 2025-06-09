// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/* ===============================================================
   📝  TUGAS BOOTCAMP
   Implementasikan multisig 2-of-3 untuk treasury BEM.
   Lengkapi bagian‐bagian bertanda  TODO:  di bawah ini.
   ============================================================== */
contract BEMMultiSigSimple {
/* ========== EVENTS ========== */
// Sudah disiapkan, tidak perlu diubah
    event Deposit(address indexed sender, uint256 amount);
    event SubmitTx(uint256 indexed txId, address indexed to, uint256 value, bytes data);
    event ConfirmTx(address indexed owner, uint256 indexed txId);
    event ExecuteTx(uint256 indexed txId, bool success);

/* ========== STATE ========== */

    // TODO: 1) simpan 3 owner
    address[] public owner = new address[](uint8(3));

    // TODO: 2) mapping isOwner
    mapping(address => bool) public isOwner;

    // TODO : 3) constant QUORUM = 2
    uint8 public constant QUORUM = uint8(2);

    // TODO : Structing
    struct TxInfo {
        address to; // - destination address
        uint256 value; // - ETH value
        bytes callData; // - calldata (bytes)
        bool isExecuted; // - executed flag
        uint8 totalConfirm; // - jumlah konfirmasi (uint8)
    }

    // TODO: deklarasi array dynamic  txs
    TxInfo[] public txs;

    // TODO: mapping confirmed[txId][owner]
    mapping(uint256 txId => mapping(address => bool)) public confirmed;

/* ========== MODIFIERS ========== */

    // TODO: onlyOwner
    modifier onlyOwner() {
        require(isOwner[msg.sender], "You aren't Owner");
        _;
    }

    // TODO: txExists
    modifier txExists(uint256 txId) {
        require(txId < txs.length, "Transaction Exist");
        _;
    }

    // TODO: notExecuted
    modifier notExecuted(uint256 txId) {
        require(!txs[txId].isExecuted, "Transaction Has Executed");
        _;
    }

    // TODO: notConfirmed
    modifier notConfirmed(uint256 txId) {
        require(!confirmed[txId][msg.sender], "Transaction Has Confirmed by You");
        _;
    }

    // TODO : Cek duplikat
    mapping(address => bool) internal addressDuplicateGuard;

/* ========== CONSTRUCTOR ========== */
/// @param _owners array 3 alamat (Ketua, Bendahara, Sekretaris)
    constructor(address[3] memory _owners) {

        for (uint i = 0; i < _owners.length; i++) {
            // TODO: Validasi alamat tidak 0x0
            require(_owners[i] == address(0), "Address can't 0x0");

            // TODO : Cek duplikat
            require(!addressDuplicateGuard[_owners[i]], "Duplication owners address");
            addressDuplicateGuard[_owners[i]] = true;

            // TODO: Set  owners[]  &  isOwner
            owner[i] = _owners[i];
            isOwner[_owners[i]] = true;
        }

    }

/* ========== RECEIVE ETHER ========== */
    receive() external payable {
        // TODO: emit Deposit event
        emit Deposit(msg.sender, msg.value);
    }

/* ========== CORE FUNCTIONS ========== */

    /// @notice Owner mengajukan transaksi baru
    /// @dev Simpan TxInfo & emit SubmitTx
    function submit(address _to, uint256 _value, bytes calldata _data)
    external onlyOwner
    {
        // TODO: Buat txId (length array)
        uint256 txId = txs.length;

        // TODO: push() struct ke array
        txs.push(TxInfo({
            to: _to,
            value: _value,
            callData: _data,
            isExecuted: false,
            totalConfirm: 0

        }));

        // TODO: emit event
        emit SubmitTx({
            txId: txId,
            to: _to,
            value: _value,
            data: _data
        });
    }

    /// @notice Owner menandatangani transaksi
    function confirm(uint256 _id)
    external onlyOwner notConfirmed(_id)
    {

        // TODO: - tandai confirmed
        confirmed[_id][msg.sender] = true;

        // TODO: - increment confirmations
        txs[_id].totalConfirm++;

        // TODO: - emit event
        emit ConfirmTx({
            owner: msg.sender,
            txId: _id
        });
    }

    /// @notice Eksekusi setelah konfirmasi ≥ QUORUM
    function execute(uint256 _id)
    external onlyOwner
    {

        TxInfo storage txContext = txs[_id];

        // TODO : pastikan quorum
        require(txContext.totalConfirm > QUORUM, "Total confirmed less than QUORUM");

        // TODO : set  executed = true  SEBELUM call
        txContext.isExecuted = true;

        // TODO : lakukan low-level call  .call{value:_value}(_data)
        (bool isSuccess,) = payable(txContext.to).call(txContext.callData);

        // TODO : emit event & revert jika gagal
        emit ExecuteTx({
            txId: _id,
            success: isSuccess
        });

        if (!isSuccess) {
            revert("Transaction Failure");
        }

    }

/* ========== GETTERS (view) ========== */

    function txCount() external view returns (uint256) {

        // TODO: return panjang array txs
        return txs.length;
    }

    function getTx(uint256 _id)
    external view
    returns (address to, uint256 value, bytes memory data, bool executed, uint8 conf)
    {
        TxInfo storage txContext = txs[_id];
        to = txContext.to;
        value = txContext.value;
        data = txContext.callData;
        executed = txContext.isExecuted;

        conf = uint8(0);
    }
}