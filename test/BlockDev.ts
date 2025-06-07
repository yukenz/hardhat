import {loadFixture,} from "@nomicfoundation/hardhat-toolbox-viem/network-helpers";
import hre from "hardhat";

describe("BlockDev", function () {
    // We define a fixture to reuse the same setup in every test.
    // We use loadFixture to run this setup once, snapshot that state,
    // and reset Hardhat Network to that snapshot in every test.
    async function deployOneYearLockFixture() {

        // Contracts are deployed using the first signer/account by default
        const [owner, otherAccount] = await hre.viem.getWalletClients();

        const tokenFactory = await hre.viem.deployContract("TokenFactory", [],{});

        const publicClient = await hre.viem.getPublicClient();

        return {
            tokenFactory,
            owner,
            otherAccount,
            publicClient,
        };
    }

    describe("Deployment", function () {

        it("Should Passed", async function () {
            const {tokenFactory,} = await loadFixture(deployOneYearLockFixture);

            console.log(tokenFactory);
        });

    });
    ;
});
