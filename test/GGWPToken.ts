import {loadFixture,} from "@nomicfoundation/hardhat-toolbox-viem/network-helpers";
import {expect} from "chai";
import hre from "hardhat";
import {getAddress} from "viem";

describe("Lock", function () {
    // We define a fixture to reuse the same setup in every test.
    // We use loadFixture to run this setup once, snapshot that state,
    // and reset Hardhat Network to that snapshot in every test.
    async function deployOneYearLockFixture() {

        // Contracts are deployed using the first signer/account by default
        const [owner, otherAccount] = await hre.viem.getWalletClients();

        const contract = await hre.viem.deployContract("GGWPToken", [BigInt('1000000000')], {});

        const publicClient = await hre.viem.getPublicClient();

        return {
            contract,
            owner,
            otherAccount,
            publicClient,
        };
    }

    describe("Deployment", function () {

        it("Should set the right owner", async function () {
            const {contract, owner} = await loadFixture(deployOneYearLockFixture);

            expect(await contract.read.balanceOf([owner.account.address])).to.equal(
                BigInt('1000000000')
            );
        });

    });

})