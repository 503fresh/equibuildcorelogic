// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MilestoneVault {
    address public admin;
    address public grantee;
    uint256 public currentMilestone;
    uint256 public totalMilestones;

    mapping(uint256 => bool) public milestoneCompleted;
    mapping(uint256 => uint256) public milestonePayout;

    constructor(address _grantee, uint256 _totalMilestones) {
        admin = msg.sender;
        grantee = _grantee;
        totalMilestones = _totalMilestones;
        currentMilestone = 1;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    function fundVault() external payable onlyAdmin {}

    function confirmMilestone(uint256 milestoneId) external onlyAdmin {
        require(milestoneId == currentMilestone, "Out of order");
        require(!milestoneCompleted[milestoneId], "Already completed");

        milestoneCompleted[milestoneId] = true;
        payable(grantee).transfer(milestonePayout[milestoneId]);

        currentMilestone += 1;
    }

    function setPayout(uint256 milestoneId, uint256 amount) external onlyAdmin {
        milestonePayout[milestoneId] = amount;
    }

    function freezeReview() public view returns (bool) {
        return block.timestamp > (block.timestamp + 30 days); // Placeholder
    }
}
