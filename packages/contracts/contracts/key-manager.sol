// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title KeyManager Contract
/// @notice Manages the creation and storage of unique keys for users, restricted to the contract owner.
/// @dev Inherits from Ownable. Uses block.timestamp and block.prevrandao for key generation.
/// @author 0xOse
contract KeyManager is Ownable {
    mapping(address => bytes32) private keyStore;

    /// @notice Emitted when a new key is created for a user.
    /// @param user The address of the user for whom the key was created.
    /// @param key The generated key associated with the user.
    event KeyCreated(address indexed user, bytes32 key);

    constructor() Ownable(msg.sender) {}

    /// @notice Internal function to generate a unique key for a user.
    /// @dev Uses block.timestamp and block.prevrandao for randomness. Only callable by the owner.
    /// @param user The address of the user for whom the key is being generated.
    /// @return The generated key as a bytes32 value.
    function _createKey(
        address user
    ) internal view onlyOwner returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(block.timestamp, user, block.prevrandao)
            );
    }

    /// @notice Registers a new user and generates a unique key for them.
    /// @dev Only callable by the owner. Reverts if the user already has a key.
    /// @param user The address of the user to register.
    function registerUser(address user) public onlyOwner {
        require(keyStore[user] == bytes32(0), "Key already exists");

        bytes32 generatedKey = _createKey(user);

        keyStore[user] = generatedKey;

        emit KeyCreated(user, generatedKey);
    }

    /// @notice Fetches the key associated with a given user.
    /// @dev Only callable by the owner. Reverts if no key is found for the user.
    /// @param user The address of the user whose key is being fetched.
    /// @return The key associated with the user.
    function fetchKey(address user) public view onlyOwner returns (bytes32) {
        bytes32 key = keyStore[user];
        require(key != bytes32(0), "No key found for this user");
        return key;
    }
}
