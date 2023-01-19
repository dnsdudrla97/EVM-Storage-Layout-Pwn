// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol";
import {DSTest} from "ds-test/test.sol";
import {Vm} from "forge-std/VM.sol";
import {ICheatCodes} from "./utils/ICheatCodes.sol";

contract StructStorage {
    struct pos {
        uint128 x;
        uint128 y;
        uint256 z;
    }
    uint256 dimension;
    mapping(uint256 => mapping(uint256 => pos)) positions;
}
