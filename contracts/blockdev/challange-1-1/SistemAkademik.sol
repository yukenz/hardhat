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

interface SistemAkademikError {
    error MahasiswaNotFount(uint256 nim);
}

contract SistemAkademik is Context, SistemAkademikError {
    struct Mahasiswa {
        string nama;
        uint256 nim;
        string jurusan;
        uint256[] nilai;
        bool isActive;
    }

    mapping(uint256 => Mahasiswa) public mahasiswa;
    mapping(address => bool) public authorized;
    uint256[] public daftarNIM;

    event MahasiswaEnrolled(uint256 nim, string nama);
    event NilaiAdded(uint256 nim, uint256 nilai);

    modifier onlyAuthorized() {
        require(authorized[msg.sender], "Tidak memiliki akses");
        _;
    }

    constructor() {
        authorized[_msgSender()] = true;
    }

// TODO: Implementasikan enrollment function

    function enrollment(string memory nama, uint256 nim, string memory jurusan, uint256[] memory nilai) public onlyAuthorized {

        uint256 indexMahasiswa = daftarNIM.length;
        mahasiswa[indexMahasiswa] = Mahasiswa(nama, nim, jurusan, nilai, true);
        daftarNIM.push(nim);

        emit MahasiswaEnrolled(nim, nama);

    }

// TODO: Implementasikan add grade function
    function addGrade(uint256 nim, uint256 nilai) public onlyAuthorized {

        // Nim Harus Ada
        uint256 indexMhsw = 0;
        for (uint i = 0; i < daftarNIM.length; i++) {

            if (daftarNIM[i] == nim) {
                indexMhsw = i + 1;
                break;
            }
        }

        if (indexMhsw == 0) {
            revert MahasiswaNotFount(nim);
        }

        // Finalize
        mahasiswa[indexMhsw - 1].nilai.push(nilai);
        emit NilaiAdded(nim, nilai);
    }
// TODO: Implementasikan get student info function
    function getStudentInfo(uint256 nim) public view returns (Mahasiswa memory){

        // Nim Harus Ada
        uint256 indexMhsw = 0;
        for (uint i = 0; i < daftarNIM.length; i++) {

            if (daftarNIM[i] == nim) {
                indexMhsw = i + 1;
                break;
            }
        }

        if (indexMhsw == 0) {
            revert MahasiswaNotFount(nim);
        }

        return mahasiswa[indexMhsw - 1];
    }
}