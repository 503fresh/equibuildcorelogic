// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ContributorRegistry {
    mapping(address => bool) private contributors;

    function addContributor(address user) public {
        contributors[user] = true;
    }

    function isContributor(address user) public view returns (bool) {
        return contributors[user];
    }
}
