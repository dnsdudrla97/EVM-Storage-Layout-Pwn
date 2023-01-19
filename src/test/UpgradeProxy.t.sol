// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol";
import {DSTest} from "ds-test/test.sol";
import {Vm} from "forge-std/VM.sol";
import {ICheatCodes} from "./utils/ICheatCodes.sol";

contract ImplFlagManagerV1 {
    bool public Initialized;
    uint256 public flag;

    function initialize(uint256 _flag) external {
        require(!Initialized, "[ERR-01] Already initialized");
        Initialized = true;
        flag = _flag;
    }

    function getFlag() external view returns (uint256) {
        return flag;
    }

    function setFlag(uint256 _flag) external {
        require(0 < _flag, "[ERR-01] Invalid flag");
        flag = _flag;
    }
}

contract ImplFlagManagerV2 {
    bool public Initialized;
    uint256 public flag;

    function initialize(uint256 _flag) external {
        require(!Initialized, "[ERR-01] Already initialized");
        Initialized = true;
        flag = _flag;
    }

    function getFlag() external view returns (uint256) {
        return flag;
    }

    function setFlag(uint256 _flag) external {
        require(0 < _flag, "[ERR-01] Invalid flag");
        flag = _flag >> 1;
    }
}

contract UpgradeProxy {
    bytes32 constant RAND_IMPL_SLOT =
        bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1);

    function upgradeTo(address _newImplementation) external {
        bytes32 slot = RAND_IMPL_SLOT;
        assembly {
            sstore(slot, _newImplementation)
        }
    }

    function implementation() public view returns (address _impl) {
        bytes32 slot = RAND_IMPL_SLOT;
        assembly {
            _impl := sload(slot)
        }
    }

    fallback() external payable {
        (bool _success, bytes memory _ret) = implementation().delegatecall(
            msg.data
        );
        require(_success, "[ERR-02] Delegate call failed");

        assembly {
            let data := add(_ret, 0x20)
            let size := mload(_ret)
            return(data, size)
        }
    }
}

contract UpgradeProxyTest is DSTest {
    Vm internal immutable vm = Vm(HEVM_ADDRESS);

    function testUpgradeProxy() public {
        ImplFlagManagerV1 logicV1 = new ImplFlagManagerV1();
        UpgradeProxy Uproxy = new UpgradeProxy();
        Uproxy.upgradeTo(address(logicV1));

        ImplFlagManagerV1 Uproxy_logicV1 = ImplFlagManagerV1(address(Uproxy));
        Uproxy_logicV1.initialize(0x41414141);

        assertEq(Uproxy_logicV1.getFlag(), 0x41414141);

        Uproxy_logicV1.setFlag(0x42424242);
        assertEq(Uproxy_logicV1.getFlag(), 0x42424242);

        ImplFlagManagerV2 logicV2 = new ImplFlagManagerV2();
        Uproxy.upgradeTo(address(logicV2));

        Uproxy_logicV1.setFlag(0x41414141);
        assertEq(Uproxy_logicV1.getFlag(), (0x41414141 >> 1));
    }
}
