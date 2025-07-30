// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MilestoneVault.sol";

contract VaultFactory {
    address[] public deployedVaults;

    event VaultCreated(address vault, address grantee, uint256 totalMilestones);

    function createVault(address grantee, uint256 totalMilestones) external {
        MilestoneVault newVault = new MilestoneVault(grantee, totalMilestones);
        deployedVaults.push(address(newVault));
        emit VaultCreated(address(newVault), grantee, totalMilestones);
    }

    function getAllVaults() external view returns (address[] memory) {
        return deployedVaults;
    }
}
