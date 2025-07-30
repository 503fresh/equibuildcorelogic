# .env.example
PRIVATE_KEY=your_wallet_key_here
INFURA_API=https://sepolia.infura.io/v3/YOUR_KEY
// deploy.js
const { ethers } = require("hardhat");

async function main() {
  const Vault = await ethers.getContractFactory("MilestoneVault");
  const vault = await Vault.deploy("0xYourGrantee", 3);
  await vault.deployed();
  console.log(`Vault deployed to: ${vault.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
