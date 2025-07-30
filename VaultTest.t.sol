// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../MilestoneVault.sol";

contract VaultTest is Test {
    MilestoneVault vault;

    function setUp() public {
        vault = new MilestoneVault(address(this), 3);
        vault.setPayout(1, 1 ether);
    }

    function testInitialMilestone() public {
        assertEq(vault.currentMilestone(), 1);
    }

    function testFundAndRelease() public {
        vm.deal(address(this), 1 ether);
        vault.fundVault{value: 1 ether}();
        vault.confirmMilestone(1);
        assertEq(address(this).balance, 1 ether); // Should receive payout
    }
}
