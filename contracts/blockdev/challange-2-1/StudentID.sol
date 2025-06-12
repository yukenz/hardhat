// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

/**
 * @title StudentID
 * @dev NFT-based student identity card
 * Features:
 * - Auto-expiry after 4 years
 * - Renewable untuk active students
 * - Contains student metadata
 * - Non-transferable (soulbound)
 */
contract StudentID is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {

    uint256 private _nextTokenId;

    struct StudentData {
        string nim;
        string name;
        string major;
        uint256 enrollmentYear;
        uint256 expiryDate;
        bool isActive;
        uint8 semester;
    }

    // TODO: Add mappings
    mapping(uint256 => StudentData) public studentData;
    mapping(string => uint256) public nimToTokenId;  // Prevent duplicate NIM
    mapping(address => uint256) public addressToTokenId;     // One ID per address

    // Events
    event StudentIDIssued(uint256 indexed tokenId, string indexed nimIndexed, string nim, address student, uint256 expiryDate);
    event StudentIDRenewed(uint256 indexed tokenId, uint256 newExpiryDate);
    event StudentStatusUpdated(uint256 indexed tokenId, bool isActive);
    event ExpiredIDBurned(uint256 indexed tokenId);

    constructor() ERC721("Student Identity Card", "SID") Ownable() {

    }

/**
 * @dev Issue new student ID
     * Use case: New student enrollment
     */
    function issueStudentID(
        address to,
        string memory nim,
        string memory name,
        string memory major,
        string memory uri
    ) public onlyOwner {

        // TODO: Implement ID issuance
        // Hints:

        // 1. Check NIM tidak duplicate (use nimToTokenId)
        require(nimToTokenId[nim] < 1, "Dulplicate NIM");

        // 2. Check address belum punya ID (use addressToTokenId)
        require(addressToTokenId[to] < 1, "Address already have ID");

        // 3. Calculate expiry (4 years from now)
        uint256 expiryDate = block.timestamp + (365 days * 4);

        uint256 tokenId = ++_nextTokenId;

        // 4. Mint NFT
        super._mint({
            to: to,
            tokenId: _nextTokenId
        });

        // 5. Set token URI (foto + metadata)
        ERC721URIStorage._setTokenURI(tokenId, uri);

        // 6. Store student data
        studentData[tokenId] = StudentData({
            nim: nim,
            name: name,
            major: major,
            enrollmentYear: block.timestamp,
            expiryDate: expiryDate,
            isActive: true,
            semester: 1
        });

        // 7. Update mappings
        nimToTokenId[nim] = tokenId;
        addressToTokenId[to] = tokenId;

        // 8. Emit event
        emit StudentIDIssued({
            tokenId: tokenId,
            nimIndexed: nim,
            nim: nim,
            student: to,
            expiryDate: expiryDate
        });
    }

    /**
     * @dev Renew student ID untuk semester baru
     */
    function renewStudentID(uint256 tokenId) public onlyOwner {
        // TODO: Extend expiry date

        // Check token exists
        require(studentData[tokenId].enrollmentYear > 0, "Student is not exist");

        // Only Expired can renew
        require(this.isExpired(tokenId), "Only Expired ID can renew");

        // Check student is active
        require(studentData[tokenId].isActive, "Student is not exist");

        // Add 6 months to expiry
        studentData[tokenId].expiryDate = block.timestamp + (365 days / 2);

        // Update semester
        studentData[tokenId].semester++;

        // Emit renewal event
        emit StudentIDRenewed({
            tokenId: tokenId,
            newExpiryDate: studentData[tokenId].expiryDate
        });
    }

    /**
     * @dev Update student status (active/inactive)
     * Use case: Cuti, DO, atau lulus
     */
    function updateStudentStatus(uint256 tokenId, bool isActive) public onlyOwner {
        // TODO: Update active status
        // If inactive, maybe reduce privileges
        studentData[tokenId].isActive = isActive;
    }

    /**
     * @dev Burn expired IDs
     * Use case: Cleanup expired cards
     */
    function burnExpired(uint256 tokenId) public {
        // TODO: Allow anyone to burn if expired
        // Check token exists
        require(studentData[tokenId].enrollmentYear > 0, "Student is not exist");
        // Check if expired (block.timestamp > expiryDate)
        require(studentData[tokenId].expiryDate < block.timestamp, "Student not expired");

        // Find Metadata
        address owner = _ownerOf(tokenId);
        string memory nim = studentData[tokenId].nim;

        // Burn token
        _burn(tokenId);

        // Clean up mappings
        delete addressToTokenId[owner];

        delete nimToTokenId[nim];

        // Emit event
        emit ExpiredIDBurned(tokenId);
    }

    /**
     @dev Check if ID is expired
     */
    function isExpired(uint256 tokenId) public view returns (bool) {

        return studentData[tokenId].expiryDate <= block.timestamp;
    }

/**
 * @dev Get student info by NIM
     */
    function getStudentByNIM(string memory nim) public view returns (
        address owner,
        uint256 tokenId,
        StudentData memory data
    ) {

        // TODO: Lookup student by NIM
        tokenId = nimToTokenId[nim];
        owner = _ownerOf(tokenId);
        data = studentData[tokenId];
    }

    /**
     * @dev Override transfer functions to make non-transferable
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override {
        // TODO: Make soulbound (non-transferable)
        // Only allow minting (from == address(0)) and burning (to == address(0))
        require(from == address(0) || to == address(0), "SID is non-transferable");
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    // Override functions required untuk multiple inheritance
    function tokenURI(uint256 tokenId)
    public
    view
    override(ERC721, ERC721URIStorage)
    returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721, ERC721URIStorage)
    returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {

        address owner = ownerOf(tokenId);
        super._burn(tokenId);
        // TODO: Clean up student data when burning
        delete studentData[tokenId];
        delete nimToTokenId[studentData[tokenId].nim];
        delete addressToTokenId[owner];
    }
}