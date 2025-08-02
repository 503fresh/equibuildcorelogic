// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ContributorRegistry {
    mapping(address => bool) private _contributors;

    function addContributor(address user) external {
        _contributors[user] = true;
    }

    function removeContributor(address user) external {
        _contributors[user] = false;
    }

    function isContributor(address user) external view returns (bool) {
        return _contributors[user];
    }
}
