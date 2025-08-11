const { expect } = require("chai");
const { ethers } = require("hardhat");

let registryMock, nft;

beforeEach(async () => {
  const Registry = await ethers.getContractFactory("ContributorRegistry");
  registryMock = await Registry.deploy();
  await registryMock.waitForDeployment();              // ✅ v6

  const registryAddr = await registryMock.getAddress(); // ✅ v6 (or registryMock.target)

  const NFT = await ethers.getContractFactory("MockMilestoneNFT");
  nft = await NFT.deploy(/* if ctor needs registryAddr, pass it here */);
  await nft.waitForDeployment();                        // ✅ v6
});
