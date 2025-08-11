const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with:", deployer.address);

  const Registry = await hre.ethers.getContractFactory("ContributorRegistry");
  const registry = await Registry.deploy();
  await registry.deployed();
  console.log("ContributorRegistry deployed at:", registry.address);

  const NFT = await hre.ethers.getContractFactory("MockMilestoneNFT");
  const nft = await NFT.deploy(registry.address);
  await nft.deployed();
  console.log("MockMilestoneNFT deployed at:", nft.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
