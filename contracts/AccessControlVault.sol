// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract AccessControlVault is AccessControl {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant REVIEWER_ROLE = keccak256("REVIEWER_ROLE");

    constructor(address admin, address reviewer) {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(ADMIN_ROLE, admin);
        _grantRole(REVIEWER_ROLE, reviewer);
    }

    modifier onlyAdmin() {
        require(hasRole(ADMIN_ROLE, msg.sender), "Not admin");
        _;
    }

    modifier onlyReviewer() {
        require(hasRole(REVIEWER_ROLE, msg.sender), "Not reviewer");
        _;
    }
}
