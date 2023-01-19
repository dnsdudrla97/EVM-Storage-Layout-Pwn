// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol";
import {DSTest} from "ds-test/test.sol";
import {Vm} from "forge-std/VM.sol";
import {ICheatCodes} from "./utils/ICheatCodes.sol";

contract SimpleStorageLayout {
    // slots: 0
    uint16 a;
    uint16 b;
    uint16 c;
    uint16 d;
    uint16 e;
    uint16 f;
    uint16 g;
    uint16 h;
    uint16 i;
    uint16 j;
    uint16 k;
    uint16 l;
    uint16 m;
    uint16 n;
    uint16 o;
    uint16 p;
    // slots: 1
    bytes12 calice;
    address alice;
    // slots: 2
    address bob;
    // slots: 3
    uint256 balance;
}
