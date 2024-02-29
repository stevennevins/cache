// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {SSTORE2} from "sstore2/SSTORE2.sol";

/// @title KeyCache
/// @notice A contract for storing key-value pairs
/// @dev This contract uses a mapping to store key-value pairs
contract KeyCache {
    using SSTORE2 for *;

    /// @dev Mapping to store the addresses for each key
    mapping(bytes32 => address) public cacheStore;

    /// @dev Emitted when content is cached
    event ContentCached(address indexed pointer, bytes32 contentChecksum);

    /// @notice Throws when content is already cached
    error ContentAlreadyCached();

    /// @dev Caches the content and returns the pointer.
    /// @param content The content to be cached.
    /// @return pointer The pointer to the cached content.
    function cache(bytes memory content) external returns (address pointer) {
        bytes32 checksum = keccak256(content);
        if (cacheStore[checksum] != address(0)) revert ContentAlreadyCached();
        pointer = content.write();
        cacheStore[checksum] = pointer;
        emit ContentCached(pointer, checksum);
    }

    /// @dev Reads the content at the given pointer.
    /// @param pointer The pointer to the cached content.
    /// @return The content at the given pointer.
    function read(address pointer) external view returns (bytes memory) {
        return pointer.read();
    }

    /// @dev Checks if the content is already cached.
    /// @param content The content to be checked.
    /// @return True if the content is already cached, false otherwise.
    function cached(bytes memory content) external view returns (bool) {
        bytes32 checksum = keccak256(content);
        return cacheStore[checksum] != address(0);
    }
}
