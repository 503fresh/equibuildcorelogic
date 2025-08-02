// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/MockMilestoneNFT.sol";
import "../contracts/ContributorRegistry.sol";

contract Phase3LogicTest is Test {
    MockMilestoneNFT nft;
    ContributorRegistry registry;

    address alice = address(0x1);
    address bob = address(0x2);

    function setUp() public {
        registry = new ContributorRegistry();
        nft = new MockMilestoneNFT(address(registry));
        registry.addContributor(alice);
        registry.addContributor(bob);
    }

    function testMintAndTransfer() public {
        vm.prank(alice);
        nft.mintMilestone(alice, "ipfs://example");
        assertEq(nft.ownerOf(1), alice);

        vm.prank(alice);
        nft.transferFrom(alice, bob, 1);
        assertEq(nft.ownerOf(1), bob);
    }

    function testRevokeBurn() public {
        vm.prank(alice);
        nft.mintMilestone(alice, "ipfs://example");

        vm.prank(alice);
        nft.setStatus(1, 2); // 2 = Revoked

        vm.expectRevert("Token does not exist");
        nft.ownerOf(1);
    }

    function testRevokedCannotTransfer() public {
        vm.prank(alice);
        nft.mintMilestone(alice, "ipfs://example");

        vm.prank(alice);
        nft.setStatus(1, 2); // Revoke

        vm.prank(alice);
        vm.expectRevert("Token revoked");
        nft.transferFrom(alice, bob, 1);
    }
}
