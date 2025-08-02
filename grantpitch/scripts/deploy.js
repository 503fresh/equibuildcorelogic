const hre = require("hardhat");

async function main() {
  const Registry = await hre.ethers.getContractFactory("ContributorRegistry");
  const registry = await Registry.deploy();
  await registry.deployed();

  console.log("ContributorRegistry deployed to:", registry.address);

  const NFT = await hre.ethers.getContractFactory("MockMilestoneNFT");
  const nft = await NFT.deploy(registry.address);
  await nft.deployed();

  console.log("MockMilestoneNFT deployed to:", nft.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
