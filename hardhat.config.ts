import type {HardhatUserConfig} from "hardhat/config";
import {vars} from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";


const config: HardhatUserConfig = {
    solidity: {
        version: "0.8.28",
        settings: {
            metadata: {
                bytecodeHash: "none",      // ⬅ prevents IPFS-hash mismatch
                useLiteralContent: true,   // ⬅ embeds the full source in metadata
            },
            optimizer: {
                enabled: true,
                runs: 200
            }
        }
    },
    networks: {
        localhost: {
            url: `http://localhost:8545`,
            chainId: 31337.,
            // chainId: 1337,
            blockGasLimit: 6721975,
            gasPrice: 20000000000,
            // accounts: {
            //     mnemonic: "auction canal ripple melt audit pilot blossom page summer broken onion boost",
            //     path: "m/44'/60'/0'/0",
            //     initialIndex: 0,
            //     count: 20,
            //     passphrase: "",
            // }
            accounts: ["0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"]
        },
        sepolia: {
            url: `https://sepolia.infura.io/v3/${vars.has("INFURA_APIKEY") ? vars.get("INFURA_APIKEY") : undefined}`
        },
        monadTestnet: {
            // url: "https://testnet-rpc.monad.xyz/",
            url: "https://soft-icy-darkness.monad-testnet.quiknode.pro/" + (vars.has("QUICKNODE_APIKEY") ? vars.get("QUICKNODE_APIKEY") : undefined),
            // url: "https://monad-testnet.g.alchemy.com/v2/" + (vars.has("ALCHEMY_APIKEY") ? vars.get("ALCHEMY_APIKEY") : undefined),
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
