import {Levels, Log} from '@toreda/log';
import {Time, timeNow} from '@toreda/time';

// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const {ethers, upgrades} = require('hardhat');

async function main() {
	const log = new Log({
		consoleEnabled: true,
		level: Levels.ALL
	});
	const startTime = timeNow();

	log.info('Initializing Controller for deployment..');
	const Controller = await ethers.getContractFactory('Controller');
	log.info('Deploying Controller Proxy..');
	const controller = await upgrades.deployProxy(Controller, [], {
		initializer: 'none'
	});

	log.info('Deploying Controller Contract..');
	await controller.deployed();
	const endTime = timeNow();
	log.info(`Controller Contract & Proxy deployed successfully in ${endTime.since(startTime)?.asSeconds()} seconds.`);

	log.info(`Deployment Details\n ------------------`);
	log.info(`Controller Contract: ${controller.address} `)
	log.info(`Proxy Contract: -`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
