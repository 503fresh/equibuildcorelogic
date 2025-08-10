// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MilestoneVault {
    address public admin;
    address public grantee;
    uint256 public totalMilestones;
    uint256 public currentMilestone;
    uint256 public extensionCount;
    bool public humanApprovalRequired;

    mapping(uint256 => bool) public milestoneCompleted;
    mapping(uint256 => bool) public milestoneExtended;

    event MilestoneCompleted(uint256 milestone);
    event ExtensionGranted(uint256 milestone);
    event HumanApprovalRequired(uint256 milestone);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier onlyGrantee() {
        require(msg.sender == grantee, "Not grantee");
        _;
    }

    constructor(address _admin, address _grantee, uint256 _total) {
        admin = _admin;
        grantee = _grantee;
        totalMilestones = _total;
        currentMilestone = 0;
        extensionCount = 0;
        humanApprovalRequired = false;
    }

    function fundVault() external payable onlyAdmin {}

    function milestonePayout(uint256 milestoneId) external onlyGrantee {
        require(!humanApprovalRequired, "Human approval required");
        require(milestoneId == currentMilestone, "Wrong milestone");
        require(!milestoneCompleted[milestoneId], "Already completed");
        milestoneCompleted[milestoneId] = true;

        // Reset extension counter if on-time
        if (!milestoneExtended[milestoneId]) {
            extensionCount = 0;
        }

        emit MilestoneCompleted(milestoneId);

        currentMilestone++;
        // payout logic here
    }

    function requestExtension() external onlyGrantee {
        require(!milestoneExtended[currentMilestone], "Extension already used for this milestone");

        milestoneExtended[currentMilestone] = true;
        extensionCount++;

        if (extensionCount >= 3) {
            humanApprovalRequired = true;
            emit HumanApprovalRequired(currentMilestone);
        }

        emit ExtensionGranted(currentMilestone);
    }

    function approveByHuman() external onlyAdmin {
        require(humanApprovalRequired, "Not required");
        humanApprovalRequired = false;
        extensionCount = 0; // reset after human approval
    }

    function getStatus() external view returns (
        uint256 milestone,
        uint256 extensions,
        bool humanApproval
    ) {
        return (currentMilestone, extensionCount, humanApprovalRequired);
    }
}
