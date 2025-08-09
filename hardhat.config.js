require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: {
    compilers: [
      { version: "0.8.28", settings: { optimizer: { enabled: true, runs: 200 } } },
      { version: "0.8.23", settings: { optimizer: { enabled: true, runs: 200 } } },
      { version: "0.8.20", settings: { optimizer: { enabled: true, runs: 200 } } }
    ]
  }
};
