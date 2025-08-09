// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVault {
    function fundVault() external payable;
    function confirmMilestone(uint256 milestoneId) external;
    function setPayout(uint256 milestoneId, uint256 amount) external;
}
