// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Vault is ERC721, Ownable {
    uint256 private _tokenIds;
    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => bool) public revoked;

    constructor() ERC721("EquibuildVault", "EQVAULT") {}

    function mint(address to, string memory uri) public onlyOwner returns (uint256) {
        _tokenIds++;
        uint256 tokenId = _tokenIds;
        _mint(to, tokenId);
        _tokenURIs[tokenId] = uri;
        return tokenId;
    }

    function revoke(uint256 tokenId) public onlyOwner {
        require(_exists(tokenId), "Nonexistent token");
        revoked[tokenId] = true;
        _burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(!_isRevoked(tokenId), "Token revoked");
        return _tokenURIs[tokenId];
    }

    function _isRevoked(uint256 tokenId) internal view returns (bool) {
        return revoked[tokenId];
    }
}
