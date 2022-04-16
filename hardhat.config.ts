import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "hardhat-jest-plugin";
import "@openzeppelin/hardhat-upgrades";
import "solidity-docgen";

import * as dotenv from "dotenv";

import {HardhatUserConfig, task} from "hardhat/config";

require("solidity-coverage");

dotenv.config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
	const accounts = await hre.ethers.getSigners();

	for (const account of accounts) {
		console.log(account.address);
	}
});

const optimizer = {
	enabled: true,
	runs: 10
};

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const config: HardhatUserConfig = {
	paths: {
		artifacts: "./dist/artifacts",
		tests: "./tests",
		root: ".",
		sources: "./contracts"
	},
	docgen: {
		outputDir: "./docs",
		pages: "single"
	},
	solidity: {
		version: "0.8.4",
		settings: {
			optimizer: optimizer
		}
	},
	networks: {
		ropsten: {
			chainId: 3,
			url: process.env.ROPSTEN_URL || "",
			accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : []
		},
		bsctest: {
			chainId: 97,
			url: process.env.BSCTEST_URL || "",
			timeout: 1000
		}
	},
	gasReporter: {
		enabled: process.env.REPORT_GAS !== undefined,
		currency: "USD"
	},
	etherscan: {
		apiKey: process.env.ETHERSCAN_API_KEY
	}
};

export default config;
