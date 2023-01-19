// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol";
import {DSTest} from "ds-test/test.sol";
import {Vm} from "forge-std/VM.sol";
import {ICheatCodes} from "./utils/ICheatCodes.sol";

interface IFallBack {
    function client() external;

    function server() external;
}

contract System {
    event Log(string message);

    function client() external {
        emit Log("client, Hello");
    }

    fallback() external {
        emit Log("[Fallback] call server");
    }
}

contract FallBackTest is DSTest {
    Vm internal immutable vm = Vm(HEVM_ADDRESS);
    event Log(string message);

    function testFallBack() public {
        IFallBack ifallback = IFallBack(address(new System()));

        vm.expectEmit(false, false, false, true);
        emit Log("client, Hello");
        ifallback.client();

        vm.expectEmit(false, false, false, true);
        emit Log("[Fallback] call server");
        ifallback.server();
    }
}
