import {loadFixture,} from "@nomicfoundation/hardhat-toolbox-viem/network-helpers";
import hre from "hardhat";
import {expect} from "chai";
import {parseEther} from "viem";

describe("Travel With Motor", function () {

        async function deployTravelWithMotor() {

            // Contracts are deployed using the first signer/account by default
            const [owner] = await hre.viem.getWalletClients();
            const sourceLocation = "Depok";
            const destinationLocation = "Jakarta";
            const distance = 100;
            const travelWithMotor = await hre.viem.deployContract("TravelWithMotor", [
                sourceLocation,
                destinationLocation,
                distance
            ], {
                value: parseEther('1')
            });

            const motorAddress = await travelWithMotor.read.motorAddreess();
            const motorCycle = await hre.viem.getContractAt(
                "MotorCycle",
                motorAddress,
                {client: {wallet: owner}}
            );


            const publicClient = await hre.viem.getPublicClient();

            return {
                motorCycle,
                travelWithMotor,
                distance,
                owner,
                publicClient,
            };
        }

        describe("Deployment", function () {
            it("Distance Equal", async function () {
                const {travelWithMotor, distance} = await loadFixture(deployTravelWithMotor);
                expect(await travelWithMotor.read.distance()).to.equal(distance);
            });

            it("Progress must 0", async function () {
                const {travelWithMotor} = await loadFixture(deployTravelWithMotor);
                expect(await travelWithMotor.read.progress()).to.equal(0);
            });

            it("Person must sender", async function () {
                const {travelWithMotor, owner} = await loadFixture(deployTravelWithMotor);
                expect((await travelWithMotor.read.person()).toLowerCase())
                    .to.eq(owner.account.address.toLowerCase());
            });

            it("Motorcycle address not null", async function () {
                const {travelWithMotor, distance} = await loadFixture(deployTravelWithMotor);
                expect(await travelWithMotor.read.motorAddreess()).to.be.not.null;
            });

            it("Motorcycle balance is 0", async function () {
                const {publicClient, motorCycle} = await loadFixture(deployTravelWithMotor);

                expect(await publicClient.getBalance({
                    address: motorCycle.address,
                })).to.eq(BigInt(0));
            });

        });

        describe("Functional Test", function () {

            it("Try to fill gas and run", async function () {

                const {travelWithMotor, publicClient, motorCycle} = await loadFixture(deployTravelWithMotor);

                await expect(travelWithMotor.write.buyGas([BigInt(1000)])).to.be.fulfilled;

                const balanceMotorcycle = await publicClient.getBalance({
                    address: motorCycle.address,
                });

                expect(balanceMotorcycle).to.eq(BigInt(200));

                await expect(travelWithMotor.write.run([2])).to.be.fulfilled
            });


        });

    }
)
;