// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;


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

interface PemilihanBEMError {
    error SudahMemilih(address sender);
    error Kandidat404(string namaKandidat);
    error Pemilih404(address sender);
}

contract PemilihanBEM is Context, PemilihanBEMError {
    struct Kandidat {
        string nama;
        string visi;
        uint256 suara;
    }

    Kandidat[] public kandidat;
    mapping(address => bool) public sudahMemilih;
    mapping(address => bool) public pemilihTerdaftar;

    uint256 public waktuMulai;
    uint256 public waktuSelesai;
    address public admin;

    event VoteCasted(address indexed voter, uint256 kandidatIndex);
    event KandidatAdded(string nama);

    modifier onlyDuringVoting() {
        require(
            block.timestamp >= waktuMulai &&
            block.timestamp <= waktuSelesai,
            "Voting belum dimulai atau sudah selesai"
        );
        _;
    }

    constructor () {
        waktuMulai = block.timestamp;
        waktuSelesai = waktuMulai + 100000000;
    }

    // TODO: Implementasikan add candidate function
    function addCandidate(string memory nama, string memory visi) public {

        Kandidat memory newKandidat = Kandidat(nama, visi, 0);
        kandidat.push(newKandidat);

        emit KandidatAdded(nama);
    }

    // TODO: Implementasikan add pemilih function
    function addVoter(address addressVoter) public {
        pemilihTerdaftar[addressVoter] = true;
    }

    // TODO: Implementasikan vote function
    function vote(string memory namaKandidat) public onlyDuringVoting {

        address voterAddress = _msgSender();

        // Pemilih harus terdaftar
        if (!pemilihTerdaftar[voterAddress]) {
            revert Pemilih404(voterAddress);
        }

        // Pemilih belum memilih
        if (sudahMemilih[voterAddress]) {
            revert SudahMemilih(voterAddress);
        }

        //Kandidat harus ada
        uint indexKandidat = 0;

        for (uint i = 0; i < kandidat.length; i++) {

            bytes32 iNama = keccak256(abi.encodePacked(kandidat[i].nama));
            bytes32 vNama = keccak256(abi.encodePacked(namaKandidat));

            if (iNama == vNama) {
                indexKandidat = i + 1;
                break;
            }
        }

        // Kandidat tidak ada
        if (indexKandidat == 0) {
            revert Kandidat404(namaKandidat);
        }

        // Finalize
        kandidat[indexKandidat - 1].suara++;
        sudahMemilih[voterAddress] = true;
        emit VoteCasted(voterAddress, indexKandidat);

    }

    // TODO: Implementasikan get results function
    function getResult() public view returns (Kandidat[] memory) {
        return kandidat;
    }

}