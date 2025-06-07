// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import {buildModule} from "@nomicfoundation/hardhat-ignition/modules";

const PemilihanBemModule = buildModule("PemilihanBemModule", (m) => {

    const tokenFactory = m.contract("TokenFactory", [], {});

    return {tokenFactory};
});

export default PemilihanBemModule;
