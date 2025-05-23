import type {HardhatUserConfig} from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";

const INFURA_API_KEY = "dwdw"

const config: HardhatUserConfig = {
    solidity: "0.8.28",
    networks: {
        // localhost: {
        //     url: `http://localhost:8545`,
        //     chainId: 1337,
        //     blockGasLimit: 6721975,
        //     gasPrice: 20000000000,
        //     accounts: {
        //         mnemonic: "auction canal ripple melt audit pilot blossom page summer broken onion boost",
        //         path: "m/44'/60'/0'/0",
        //         initialIndex: 0,
        //         count: 20,
        //         passphrase: "",
        //     }
        // },
        sepolia: {
            url: `https://sepolia.infura.io/v3/${INFURA_API_KEY}`
        }
    }
};

export default config;
