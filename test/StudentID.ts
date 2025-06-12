import { expect } from "chai";
import { after, before, it } from "mocha";
import hre from "hardhat";
import {
    bytesToHex,
    bytesToString,
    hexToBytes,
    hexToString,
    parseAbiItem,
    publicActions,
    stringToBytes,
    walletActions,
    encodePacked,
    encodeAbiParameters,
    decodeAbiParameters,
    parseAbi,
    stringToHex,
    keccak256
} from "viem";

import {
    time,
    loadFixture,
} from "@nomicfoundation/hardhat-toolbox-viem/network-helpers";

describe("StudentID", function () {

    // Main Component
    const testClientTyped = async (account: `0x${string}`) => (await hre.viem.getTestClient({
        account: account
    }))
        .extend(publicActions).extend(walletActions);

    const walletClientsTyped = async () => (await hre.viem.getWalletClients());
    const studentIdTyped = async () => (await hre.viem.deployContract("StudentID", [], {}));

    let testClient: Awaited<ReturnType<typeof testClientTyped>>;
    let walletClients: Awaited<ReturnType<typeof walletClientsTyped>>;
    let studentId: Awaited<ReturnType<typeof studentIdTyped>>;

    // Testing Component
    type TestAccount = (typeof walletClients extends (infer U)[] ? U : never)['account'];

    let accountExecutor: TestAccount;
    let student1: TestAccount;
    let student2: TestAccount;

    const eventStudentIDIssued = parseAbiItem('event StudentIDIssued(uint256 indexed tokenId, string indexed nimIndexed, string nim, address student, uint256 expiryDate)');
    const eventStudentIDRenewed = parseAbiItem('event StudentIDRenewed(uint256 indexed tokenId, uint256 newExpiryDate)');
    const eventStudentStatusUpdated = parseAbiItem('event StudentStatusUpdated(uint256 indexed tokenId, bool isActive)');
    const eventExpiredIDBurned = parseAbiItem('event ExpiredIDBurned(uint256 indexed tokenId)');

    // SetUp
    before(async () => {
        walletClients = await walletClientsTyped()
        const [owner, acc1, acc2] = walletClients;
        accountExecutor = owner.account;
        student1 = acc1.account;
        student2 = acc2.account;

        testClient = await testClientTyped(accountExecutor.address)
        studentId = await studentIdTyped()
    })

    // Tear Down
    after(() => {
        console.log("Test Finish");
    });


    // ==========
    it("1 - Issued Student ID", async function () {

        const nim = "123123";

        const trx1 = await studentId.write.issueStudentID([
            student1.address,
            nim,
            "Yuyun Purniawan",
            "Bachelor Degree",
            "http://localhost:1337"
        ]);

        const trx1Receipt = await testClient.getTransactionReceipt({
            hash: trx1
        });

        // Logging Event
        const logs = await testClient.getLogs({
            event: eventStudentIDIssued,
            blockHash: trx1Receipt.blockHash,
            args: {
                nimIndexed: nim
            }
        });

        const nimAtLogs = logs
            .map(val => val.args.nim);

        expect(nimAtLogs[0]).to.be.equals(nim);


        let cardId1: bigint;
        let cardId2: bigint;

        // 2.1 Test Student ID
        describe("1.1 - Test Student", function () {

            it("1.1.1 - Minting new ID", async function () {

                await expect(studentId.write.issueStudentID([
                    student2.address,
                    nim + "99",
                    "Yuyun Purniawan 99",
                    "Bachelor Degree",
                    "http://localhost:1337"
                ])).to.be.fulfilled;
            })

            it("1.1.2 - Get Student By NIM", async function () {

                const tx1 = await studentId.read.getStudentByNIM([
                    nim
                ]);

                const [owner1, cardIdResult1] = tx1;
                cardId1 = cardIdResult1;

                const tx2 = await studentId.read.getStudentByNIM([
                    nim + "99"
                ]);

                const [owner2, cardIdResult2] = tx2;
                cardId2 = cardIdResult2;


                console.log({ cardId1, cardId2 });


                expect(owner1?.toLowerCase()).to.be.equals(student1.address);
                expect(owner2?.toLowerCase()).to.be.equals(student2.address);
            })

            it("1.1.3 - Majukan timestamp 7 tahun", async function () {

                const currentTimestamp = await time.latest();
                const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;

                await time.setNextBlockTimestamp(
                    BigInt(currentTimestamp + (ONE_YEAR_IN_SECS * 7))
                );

            })

            it("1.1.4 - Renewing ID Student1", async function () {

                const trx = await studentId.write.renewStudentID([
                    cardId1
                ]);

                const trxReceipt = await testClient.getTransactionReceipt({
                    hash: trx
                });

                // Logging Event
                const logs = await testClient.getLogs({
                    event: eventStudentIDRenewed,
                    blockHash: trxReceipt.blockHash,
                    args: {
                        tokenId: cardId1
                    }
                });

                const currentTimestampLess = (await time.latest()) - 1000;

                const renewLog = logs
                    .map(val => val.args)[0];

                console.log({ currentTimestampLess, renewLog });

                expect(Number(renewLog.newExpiryDate))
                    .to.be.greaterThan(currentTimestampLess);

            })

            it("1.1.5 - Burn Expired ID", async function () {

                const trx = await studentId.write.burnExpired([
                    cardId2
                ]);

                const trxReceipt = await testClient.getTransactionReceipt({
                    hash: trx
                });

                // Logging Event
                const logs = await testClient.getLogs({
                    event: eventExpiredIDBurned,
                    blockHash: trxReceipt.blockHash,
                    args: {
                        tokenId: cardId2
                    }
                });

                const burningLog = logs
                    .map(val => val.args)[0];

                expect(burningLog.tokenId)
                    .to.be.equals(cardId2);

            })

            it("1.1.6 - Read Token URI from Student 1", async function () {

                const tokenURI = await studentId.read.tokenURI([
                    cardId1
                ]);

                expect(tokenURI)
                    .to.be.equals("http://localhost:1337");

            })



        })

    })

})