// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import {buildModule} from "@nomicfoundation/hardhat-ignition/modules";

const IDRCModule = buildModule("IDRCModule", (m) => {

    const idrc = m.contract("IDRC", [], {});

    return {idrc};
});

export default IDRCModule;
