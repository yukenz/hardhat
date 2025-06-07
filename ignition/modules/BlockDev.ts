// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import {buildModule} from "@nomicfoundation/hardhat-ignition/modules";

const BlockDevModule = buildModule("BlockDevModule", (m) => {

    const digitalWalletKampus = m.contract("DigitalWalletKampus", [], {});
    const pemilihanBEM = m.contract("PemilihanBEM", [], {});
    const sistemAkademik = m.contract("SistemAkademik", [], {});

    return {digitalWalletKampus, pemilihanBEM, sistemAkademik};
});

export default BlockDevModule;
