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
    // mapping(uint256 => StudentData) public studentData;
    // mapping(string => uint256) public nimToTokenId;  // Prevent duplicate NIM
    // mapping(address => uint256) public addressToTokenId;     // One ID per address

    // Events
    event StudentIDIssued(
        uint256 indexed tokenId,
        string nim,
        address student,
        uint256 expiryDate
    );
    event StudentIDRenewed(uint256 indexed tokenId, uint256 newExpiryDate);
    event StudentStatusUpdated(uint256 indexed tokenId, bool isActive);
    event ExpiredIDBurned(uint256 indexed tokenId);

    constructor() ERC721("Student Identity Card", "SID") Ownable() {}

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
    // 2. Check address belum punya ID (use addressToTokenId)
    // 3. Calculate expiry (4 years from now)
    // 4. Mint NFT
    // 5. Set token URI (foto + metadata)
    // 6. Store student data
    // 7. Update mappings
    // 8. Emit event
    }

/**
 * @dev Renew student ID untuk semester baru
     */
    function renewStudentID(uint256 tokenId) public onlyOwner {
    // TODO: Extend expiry date
    // Check token exists
    // Check student is active
    // Add 6 months to expiry
    // Update semester
    // Emit renewal event
    }

/**
 * @dev Update student status (active/inactive)
     * Use case: Cuti, DO, atau lulus
     */
    function updateStudentStatus(uint256 tokenId, bool isActive) public onlyOwner {
    // TODO: Update active status
    // If inactive, maybe reduce privileges
    }

/**
 * @dev Burn expired IDs
     * Use case: Cleanup expired cards
     */
    function burnExpired(uint256 tokenId) public {
    // TODO: Allow anyone to burn if expired
    // Check token exists
    // Check if expired (block.timestamp > expiryDate)
    // Burn token
    // Clean up mappings
    // Emit event
    }

/**
 * @dev Check if ID is expired
     */
    function isExpired(uint256 tokenId) public view returns (bool) {
    // TODO: Return true if expired
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
    // require(from == address(0) || to == address(0), "SID is non-transferable");
    // super._beforeTokenTransfer(from, to, tokenId, batchSize);
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
        super._burn(tokenId);
    // TODO: Clean up student data when burning
    // delete studentData[tokenId];
    // delete nimToTokenId[studentData[tokenId].nim];
    // delete addressToTokenId[ownerOf(tokenId)];
    }
}