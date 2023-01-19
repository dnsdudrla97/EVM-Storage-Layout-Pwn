// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol";
import {DSTest} from "ds-test/test.sol";
import {Vm} from "forge-std/Vm.sol";
import {ICheatCodes} from "./utils/ICheatCodes.sol";

contract StorageLayout {
    address immutable owner;
    uint256 public flag;
    mapping(address => uint256) public users;
    bytes public key;

    constructor(bytes memory _key) {
        owner = msg.sender;
        key = _key;
    }

    function setFlags(address _user, uint256 _flag) external {
        require(msg.sender == owner, "[ERR-01] Only owner can set flags");
        users[_user] = _flag;
    }
}

contract StorageLayoutTest is DSTest {
    Vm internal immutable vm = Vm(HEVM_ADDRESS);

    StorageLayout internal storageLayout;
    address internal minsu;

    function setUp() public {
        minsu = address(uint160(uint256(keccak256(abi.encodePacked("owner")))));
        vm.label(minsu, "Owner");
    }

    function testSetFlags() public {
        vm.startPrank(address(minsu));
        storageLayout = new StorageLayout("BBBB");
        storageLayout.setFlags(minsu, uint256(0x41414141));
        vm.stopPrank();
        bytes32 minsuStorageSlot = keccak256(
            abi.encodePacked(uint256(uint160(minsu)), uint256(1))
        );

        uint256 minsuStorageSlotValue = uint256(
            vm.load(address(storageLayout), minsuStorageSlot)
        );

        assertEq(minsuStorageSlotValue, storageLayout.users(minsu));
    }
}
