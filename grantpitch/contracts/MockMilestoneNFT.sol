
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

interface IContributorRegistry {
    function isContributor(address user) external view returns (bool);
}

contract MockMilestoneNFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    IContributorRegistry private registry;

    enum Status { Active, Completed, Revoked }
    mapping(uint256 => Status) public milestoneStatus;
    mapping(uint256 => string) private _tokenURIs;

    constructor(address registryAddress) ERC721("MilestoneNFT", "MSNFT") {
        registry = IContributorRegistry(registryAddress);
    }

    function mintMilestone(address recipient, string memory uri) public {
        require(registry.isContributor(recipient), "Recipient not in registry");
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _tokenURIs[newItemId] = uri;
        milestoneStatus[newItemId] = Status.Active;
    }

    function setStatus(uint256 tokenId, uint8 status) public {
        require(_exists(tokenId), "Token does not exist");
        milestoneStatus[tokenId] = Status(status);
        if (status == uint8(Status.Revoked)) {
            _burn(tokenId);
        }
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        return _tokenURIs[tokenId];
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
        require(milestoneStatus[tokenId] != Status.Revoked, "Token revoked");

        if (to != address(0)) {
            require(registry.isContributor(to), "Receiver not in registry");
        }
    }
}
