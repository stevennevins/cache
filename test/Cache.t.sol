// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {KeyCache} from "../src/KeyCache.sol";
import {SSTORE2} from "sstore2/SSTORE2.sol";

contract KeyCacheTest is Test {
    KeyCache internal cache;

    function setUp() public {
        cache = new KeyCache();
    }

    function test_Write() public {
        cache.cache(abi.encode(new uint256[](4)));
    }

    function test_RevertsWriteTwice() public {
        cache.cache(abi.encode(new uint256[](4)));
        vm.expectRevert();
        cache.cache(abi.encode(new uint256[](4)));
    }

    function test_Read() public {
        vm.pauseGasMetering();
        address pointer = cache.cache(abi.encodePacked(new uint256[](4)));
        vm.resumeGasMetering();

        bytes memory data = SSTORE2.read(pointer);

        assertEq(128, data.length);
        abi.decode(data, (uint256[4]));
    }
}
