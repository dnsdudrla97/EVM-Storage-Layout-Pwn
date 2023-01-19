// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol";
import {DSTest} from "ds-test/test.sol";
import {Vm} from "forge-std/VM.sol";
import {ICheatCodes} from "./utils/ICheatCodes.sol";

contract ArrayStorage {
    uint256 public a;
    uint256 public b;
    uint256[] public blocks;

    function init() public {
        // blocks.length = 3;
        blocks[0] = 0x41414141;
        blocks[1] = 0x42424242;
        blocks[2] = 0x43434343;
    }
}

contract ArrayStorageTest is DSTest {
    Vm internal immutable vm = Vm(HEVM_ADDRESS);

    function testArrayStorage() public {
        ArrayStorage arrayStorage = new ArrayStorage();
        arrayStorage.init();
    }
}
