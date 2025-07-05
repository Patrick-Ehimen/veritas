// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title IdentityReport - Soulbound ERC721 for Negative Reports
/// @author
/// @notice This contract issues non-transferable (soulbound) NFTs representing negative identity reports.
/// @dev Inherits from OpenZeppelin ERC721, ERC721Burnable, and Ownable.
contract IdentityReport is ERC721, ERC721Burnable, Ownable {
    /// @notice Counter for token IDs
    uint256 private _tokenCounter = 1;

    /// @notice Initializes the contract and sets the owner
    /// @param ownerAddress The address that will be the owner of the contract
    constructor(
        address ownerAddress
    ) ERC721("Identity Report", "IDR") Ownable(ownerAddress) {}

    /// @notice Struct to store details of a negative report
    /// @param topic The topic of the report
    /// @param details The details of the report
    /// @param organization The organization issuing the report
    struct ReportDetails {
        string topic;
        string details;
        string organization;
    }

    /// @notice Maps user addresses to their token IDs (not used in logic)
    mapping(address => uint256[]) public userToTokenIds;

    /// @notice Maps user addresses to their array of report details
    mapping(address => ReportDetails[]) public userToReports;

    /// @notice Issues a new negative NFT to a recipient
    /// @dev Only callable by the contract owner
    /// @param recipient The address receiving the NFT
    /// @param topic_ The topic of the report
    /// @param details_ The details of the report
    /// @param organization_ The organization issuing the report
    function issueNegativeNFT(
        address recipient,
        string memory topic_,
        string memory details_,
        string memory organization_
    ) public onlyOwner {
        uint256 newTokenId = _tokenCounter++;
        userToReports[recipient].push(
            ReportDetails(topic_, details_, organization_)
        );
        _safeMint(recipient, newTokenId);
    }

    /// @notice Retrieves all reports for a given account
    /// @dev Only callable by the contract owner
    /// @param account The address to query reports for
    /// @return Array of ReportDetails for the account
    function getReports(
        address account
    ) public view onlyOwner returns (ReportDetails[] memory) {
        return userToReports[account];
    }

    /// @notice Internal function to restrict token transfers (soulbound logic)
    /// @dev Only allows minting and burning, reverts on transfers
    /// @param recipient The address receiving the token
    /// @param tokenId The token ID being updated
    /// @param operator The address performing the operation
    /// @return The previous owner address
    function _update(
        address recipient,
        uint256 tokenId,
        address operator
    ) internal override returns (address) {
        address sender = _ownerOf(tokenId);

        // Only allow minting (sender == address(0)) and burning (recipient == address(0))
        if (sender != address(0) && recipient != address(0)) {
            revert("Soulbound: token cannot be transferred");
        }

        return super._update(recipient, tokenId, operator);
    }
}
