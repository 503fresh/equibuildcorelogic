const hre = require("hardhat");
async function main() {
  const FACTORY = process.env.FACTORY || "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";
  const f = await hre.ethers.getContractAt("VaultFactory", FACTORY);
  const [admin, grantee] = await hre.ethers.getSigners();

  const tx = await f.createVault(grantee.address, 3);
  await tx.wait();

  const vAddr = (await f.getAllVaults()).at(-1);
  const v = await hre.ethers.getContractAt("MilestoneVault", vAddr);
  console.log("Vault:", vAddr);

  await (await v.connect(admin).fundVault({ value: hre.ethers.parseEther("1") })).wait();
  await (await v.connect(grantee).requestExtension()).wait();
  await (await v.connect(grantee).milestonePayout(0)).wait();
  await (await v.connect(grantee).requestExtension()).wait();
  try { await (await v.connect(grantee).requestExtension()).wait(); } catch { console.log("needs admin"); }
  console.log("humanApprovalRequired:", await v.humanApprovalRequired());
  await (await v.connect(admin).approveByHuman()).wait();
  await (await v.connect(grantee).milestonePayout(1)).wait();
  console.log("currentMilestone:", (await v.currentMilestone()).toString());
}
main().catch(e => (console.error(e), process.exit(1)));
