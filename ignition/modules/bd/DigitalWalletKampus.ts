// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import {buildModule} from "@nomicfoundation/hardhat-ignition/modules";

const DigitalWalletKampusModule = buildModule("DigitalWalletKampusModule", (m) => {

    const digitalWalletKampus = m.contract("DigitalWalletKampus", [], {});

    return {digitalWalletKampus};
});

export default DigitalWalletKampusModule;
