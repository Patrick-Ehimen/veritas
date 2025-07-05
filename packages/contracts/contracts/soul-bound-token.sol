// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Identity Soulbound Token (SBT)
/// @notice Implements a non-transferable ERC721 token for decentralized identity
/// @dev Only the contract owner can issue or view identities
contract SoulBoundToken is ERC721, ERC721Burnable, Ownable {
    /// @notice Counter for token IDs
    uint256 private _tokenCounter = 1;

    /// @notice Deploys the contract and sets the admin as owner
    /// @param admin The address to be set as the contract owner
    constructor(
        address admin
    ) ERC721("Decentralized Identity", "DID") Ownable(admin) {}

    /// @notice Struct to store identity data
    /// @param identifier Unique identifier for the user
    /// @param birthdate User's birthdate
    /// @param fullname User's full name
    struct IdentityData {
        string identifier;
        string birthdate;
        string fullname;
    }

    /// @notice Maps wallet addresses to their token IDs
    mapping(address => uint256) public walletToToken;
    /// @notice Maps wallet addresses to their identity data
    mapping(address => IdentityData) public walletToIdentity;

    /// @notice Issues a new identity SBT to a recipient
    /// @dev Only callable by the contract owner. Each address can have only one identity.
    /// @param recipient The address to receive the SBT
    /// @param id The unique identifier for the identity
    /// @param dob The birthdate of the identity
    /// @param name The full name of the identity
    function issueIdentity(
        address recipient,
        string memory id,
        string memory dob,
        string memory name
    ) public onlyOwner {
        require(walletToToken[recipient] == 0, "Identity already issued");
        uint256 newTokenId = _tokenCounter++;
        walletToToken[recipient] = newTokenId;
        walletToIdentity[recipient] = IdentityData(id, dob, name);
        _safeMint(recipient, newTokenId);
    }

    /// @notice Retrieves the identity data associated with a given user address.
    /// @dev Only the contract owner can call this function.
    /// @param user The address of the user whose identity data is being requested.
    /// @return The IdentityData struct associated with the provided user address.
    function getIdentity(
        address user
    ) public view onlyOwner returns (IdentityData memory) {
        return walletToIdentity[user];
    }

    /// @notice Internal function to update token ownership, enforcing soulbound (non-transferable) behavior.
    /// @dev Only allows minting (when `from` is the zero address) and burning (when `to` is the zero address).
    ///      Reverts if an attempt is made to transfer the token between non-zero addresses.
    /// @param to The address to which the token is being minted or burned (zero address for burn).
    /// @param tokenId The ID of the token being updated.
    /// @param operator The address initiating the update.
    /// @return The previous owner address of the token.
    // Prevent transfers except minting and burning
    function _update(
        address to,
        uint256 tokenId,
        address operator
    ) internal virtual override returns (address) {
        address from = _ownerOf(tokenId);

        // Only allow minting (from == address(0)) and burning (to == address(0))
        if (from != address(0) && to != address(0)) {
            revert("SBT: non-transferable token");
        }

        return super._update(to, tokenId, operator);
    }
}
