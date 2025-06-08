import type {HardhatUserConfig} from "hardhat/config";
import {vars} from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";


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
            url: `https://sepolia.infura.io/v3/${vars.has("INFURA_APIKEY") ? vars.get("INFURA_APIKEY") : undefined}`
        },
        monadTestnet: {
            // url: "https://testnet-rpc.monad.xyz/",
            url: "https://monad-testnet.g.alchemy.com/v2/" + (vars.has("ALCHEMY_APIKEY") ? vars.get("ALCHEMY_APIKEY") : undefined),
            chainId: 10143,
            accounts: vars.has("PRIVATE_KEY") ? [`0x${vars.get("PRIVATE_KEY")}`] : [],
            gasPrice: "auto",
        }
    },
    // Start -- Add On BlockDev
    sourcify: {
        enabled: true,
        apiUrl: "https://sourcify-api-monad.blockvision.org",
        browserUrl: "https://testnet.monadexplorer.com",
    },
    etherscan: {
        enabled: false,
    },
    gasReporter: {
        enabled: true,
        currency: 'USD',
        outputFile: "gas-report.txt",
        noColors: true,
    },
    // Start -- End
};

export default config;
