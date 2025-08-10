// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MilestoneVault.sol";

/// Admin = the caller (msg.sender). Admin is only for extensions/oversight.
contract VaultFactory {
    address[] private _vaults;

    event VaultCreated(address indexed vault, address indexed admin, address indexed grantee, uint256 totalMilestones);

    /// Create a vault. Admin becomes msg.sender. Grantee receives payouts.
    function createVault(address grantee, uint256 totalMilestones) external returns (address) {
        require(grantee != address(0), "grantee=0");
        require(totalMilestones > 0, "total=0");

        MilestoneVault v = new MilestoneVault(msg.sender, grantee, totalMilestones);
        _vaults.push(address(v));

        emit VaultCreated(address(v), msg.sender, grantee, totalMilestones);
        return address(v);
    }

    function getAllVaults() external view returns (address[] memory) {
        return _vaults;
    }

    function deployedVaults(uint256 i) external view returns (address) {
        return _vaults[i];
    }
}
