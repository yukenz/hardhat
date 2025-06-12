// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import {buildModule} from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("BlockDev2Module", (m) => {

    const weightedMultiSigWallet = m.contract("WeightedMultiSigWallet", [10143, 500_000], {});

    return {weightedMultiSigWallet};
});

