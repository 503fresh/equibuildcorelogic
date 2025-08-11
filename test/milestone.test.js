const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Milestone NFT Protocol", function () {
  let MilestoneNFT, milestoneNFT;
  let RegistryMock, registryMock;
  let owner, contributor;

  beforeEach(async function () {
    [owner, contributor] = await ethers.getSigners();

    RegistryMock = await ethers.getContractFactory("ContributorRegistry");
    registryMock = await RegistryMock.deploy();
    await registryMock.deployed();

    await registryMock.addContributor(contributor.address);
    await registryMock.addContributor(owner.address);

    MilestoneNFT = await ethers.getContractFactory("MockMilestoneNFT");
    milestoneNFT = await MilestoneNFT.deploy(registryMock.address);
    await milestoneNFT.deployed();
  });

  it("should allow verified contributors to mint and transfer", async function () {
    const metadataURI = "ipfs://example-metadata";
    await milestoneNFT.connect(owner).mintMilestone(contributor.address, metadataURI);
    const tokenId = 1;

    expect(await milestoneNFT.ownerOf(tokenId)).to.equal(contributor.address);
    await milestoneNFT.connect(contributor).transferFrom(contributor.address, owner.address, tokenId);
    expect(await milestoneNFT.ownerOf(tokenId)).to.equal(owner.address);
  });

  it("should revoke and burn milestone on breach", async function () {
    const metadataURI = "ipfs://example-metadata";
    await milestoneNFT.connect(owner).mintMilestone(contributor.address, metadataURI);
    const tokenId = 1;

    await milestoneNFT.connect(owner).setStatus(tokenId, 2); // Revoke and burn

    try {
      await milestoneNFT.ownerOf(tokenId);
      expect.fail("Expected error not received");
    } catch (err) {
      expect(err.message).to.include("invalid token ID");
    }
  });
});
