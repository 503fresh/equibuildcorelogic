// hardhat.config.js
require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");

const normalizePk = (pk) => (!pk ? undefined : pk.startsWith("0x") ? pk : `0x${pk}`);

const SEPOLIA_RPC_URL   = process.env.SEPOLIA_RPC_URL || "";
const PRIVATE_KEY       = normalizePk(process.env.PRIVATE_KEY);
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || "";

module.exports = {
  solidity: {
    version: "0.8.24",
    settings: { optimizer: { enabled: true, runs: 200 } },
  },
  networks: {
    hardhat: {},
    sepolia: (SEPOLIA_RPC_URL && PRIVATE_KEY) ? {
      url: SEPOLIA_RPC_URL,
      accounts: [PRIVATE_KEY],
    } : {},
  },
  etherscan: { apiKey: ETHERSCAN_API_KEY },
};
