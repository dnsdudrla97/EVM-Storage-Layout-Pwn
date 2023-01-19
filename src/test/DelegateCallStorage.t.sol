// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol";
import {DSTest} from "ds-test/test.sol";
import {Vm} from "forge-std/VM.sol";
import {ICheatCodes} from "./utils/ICheatCodes.sol";
Vm constant VM = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

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

contract DelegateCallFlagManager {
    uint256 public flag;

    function getFlag() external view returns (uint256) {
        return flag;
    }

    function delegateCallGet(ImplFlagManagerV1 _impl)
        external
        returns (uint256)
    {
        bytes memory payload = abi.encodeWithSignature("getFlag()");
        console.logBytes(payload);
        (bool _success, bytes memory _ret) = address(_impl).delegatecall(
            payload
        );
        require(_success, "[ERR-02] Delegate call failed");

        return abi.decode(_ret, (uint256));
    }

    function delegateCallSet(ImplFlagManagerV1 _impl, uint256 _flag) external {
        bytes memory payload = abi.encodeWithSignature(
            "setFlag(uint256)",
            _flag
        );
        console.logBytes(payload);
        (bool _success, ) = address(_impl).delegatecall(payload);
        require(_success, "[ERR-02] Delegate call failed");
    }

    function delegateCallGenericGet(ImplFlagManagerV1 _impl)
        external
        returns (uint256)
    {
        bytes memory payload = abi.encodeWithSignature("getFlag()");
        (bool _success, bytes memory _ret) = address(_impl).delegatecall(
            payload
        );
        require(_success, "[ERR-02] Delegate call failed");
        assembly {
            let data := add(_ret, 0x20)
            let size := mload(_ret)
            return(data, size)
        }
    }
}

contract DelegateCallStorageTest is DSTest {
    function testDelegateCall() public {
        ImplFlagManagerV1 impl = new ImplFlagManagerV1();
        DelegateCallFlagManager delegateCallFlagManager = new DelegateCallFlagManager();

        assertEq(impl.getFlag(), 0);
        assertEq(delegateCallFlagManager.getFlag(), 0);

        delegateCallFlagManager.delegateCallSet(impl, 0x41414141);

        assertEq(impl.getFlag(), 0);
        assertEq(delegateCallFlagManager.getFlag(), 0x41414141);

        assertEq(
            delegateCallFlagManager.delegateCallGet(impl),
            delegateCallFlagManager.getFlag()
        );
        assertEq(
            delegateCallFlagManager.delegateCallGenericGet(impl),
            delegateCallFlagManager.getFlag()
        );
    }
}
