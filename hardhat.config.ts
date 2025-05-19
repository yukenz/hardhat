import type {HardhatUserConfig} from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";

const INFURA_API_KEY = "dwdw"

const config: HardhatUserConfig = {
    solidity: "0.8.28",
    networks:{
        sepolia:{
            url: `https://sepolia.infura.io/v3/${INFURA_API_KEY}`,
        }
    }
};

export default config;
