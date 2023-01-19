// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol";
import {DSTest} from "ds-test/test.sol";
import {Vm} from "forge-std/VM.sol";
import {ICheatCodes} from "./utils/ICheatCodes.sol";

contract ImplFlagManagerV1 {
    uint256 public flag;

    function getFlag() external view returns (uint256) {
        return flag;
    }

    function setFlag(uint256 _flag) external {
        require(0 < _flag, "[ERR-01] Invalid flag");
        flag = _flag;
    }
}

contract FallBackProxy {
    address public impl;

    function upgradeTo(address _impl) external {
        impl = _impl;
    }

    fallback() external payable {
        console.logBytes(msg.data);

        (bool _success, bytes memory _ret) = impl.delegatecall(msg.data);
        require(_success, "[ERR-02] Delegate call failed");

        assembly {
            let data := add(_ret, 0x20)
            let size := mload(_ret)
            return(data, size)
        }
    }
}

contract FallBackProxyTest is DSTest {
    Vm internal immutable vm = Vm(HEVM_ADDRESS);

    function testFallBackProxy() public {
        ImplFlagManagerV1 impl = new ImplFlagManagerV1();
        FallBackProxy proxy = new FallBackProxy();

        vm.expectEmit(false, false, false, true);
        proxy.upgradeTo(address(impl));
        vm.expectEmit(false, false, false, true);
        ImplFlagManagerV1(address(proxy)).setFlag(0x41414141);

        ImplFlagManagerV1(address(proxy)).getFlag();
    }
}
