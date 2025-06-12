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

describe("CourseBadge", function () {

    // Main Component
    const testClientTyped = async (account: `0x${string}`) => (await hre.viem.getTestClient({
        account: account
    }))
        .extend(publicActions).extend(walletActions);

    const walletClientsTyped = async () => (await hre.viem.getWalletClients());
    const courseBadgeTyped = async () => (await hre.viem.deployContract("CourseBadge", [], {}));

    let testClient: Awaited<ReturnType<typeof testClientTyped>>;
    let walletClients: Awaited<ReturnType<typeof walletClientsTyped>>;
    let courseBadge: Awaited<ReturnType<typeof courseBadgeTyped>>;

    // Testing Component
    type TestAccount = (typeof walletClients extends (infer U)[] ? U : never)['account'];

    let accountExecutor: TestAccount;
    let student1: TestAccount;
    let student2: TestAccount;

    // SetUp
    before(async () => {
        walletClients = await walletClientsTyped()
        const [owner, acc1, acc2] = walletClients;
        accountExecutor = owner.account;
        student1 = acc1.account;
        student2 = acc2.account;

        testClient = await testClientTyped(accountExecutor.address)
        courseBadge = await courseBadgeTyped()
    })

    // Tear Down
    after(() => {
        console.log("Test Finish");
    });


    // ==========

    // 1.0 Create Cert Type
    it("1.0 - Create Certificate Type", async function () {

        const trx1 = await courseBadge.write.createCertificateType([
            // Transaction
            "BlockDevId", BigInt(Number.MAX_SAFE_INTEGER), "http://localhost"
        ]);

        const trx1Receipt = await testClient.getTransactionReceipt({
            hash: trx1
        });

        // Logging Event
        const logs = await testClient.getLogs({
            event: parseAbiItem('event CreateCertificateType(address indexed minter, uint256 certId)'),
            blockHash: trx1Receipt.blockHash,
            args: {
                minter: accountExecutor.address
            }
        });

        const certIds = logs
            .map(val => val.args.certId)

        expect(Number(certIds[0]!)).to.be.greaterThan(0);

        // 1.1 Test Certificate Type
        describe("1.1 - Test Certificate", function () {

            // 1.1.1 Issue Cert
            it('1.1.1 - Issue Certificate', async () => {

                const trx1 = await courseBadge.write.issueCertificate([
                    student1.address,
                    certIds[0]!,
                    "NODATA"
                ]);

                expect(trx1).to.be.not.null;
            });


            // 1.1.2 Verify Cert
            it('1.1.2 - Verify Certificate ', async () => {

                const earnedAt = await courseBadge.read
                    .earnedAt([certIds[0]!, student1.address]);

                const badge = await courseBadge.read
                    .studentBadges([student1.address, BigInt(0)]);

                expect(Number(earnedAt)).to.be.greaterThan(0);
            });

            // 1.1.3 Set  Cert URI and Verify Changes
            it("1.1.3 - Set Token URI", async function () {


                // TRX 1
                await expect(courseBadge.write.setTokenURI([
                    certIds[0]!, "https://localhost:8080"
                ])).to.be.fulfilled;

                const uri = await courseBadge
                    .read.uri([
                        certIds[0]!
                    ]);

                expect(uri)
                    .to.be.equals("https://localhost:8080");
            })
        })
    })

    // 2.0 Mint Event Badge
    it("2.0 - Mint Event Badge", async function () {

        const eventBadgeBase = await courseBadge.read.EVENT_BADGE_BASE();
        const eventId = BigInt(1);

        // Do Trx
        const trxHash = await courseBadge.write.mintEventBadges([
            [student1.address, student2.address],
            eventId,
            BigInt(10)
        ]);

        // Get Receipt
        const trxReceipt = await testClient.getTransactionReceipt({
            hash: trxHash
        });

        const logs = await testClient.getLogs({
            event: parseAbiItem('event MintEventBadges(address minter,address indexed student,uint256 indexed eventId,uint256 indexed badgeId)'),
            blockHash: trxReceipt.blockHash,
            args: {
                student: [student1.address, student2.address],
                eventId
            }
        });

        const badges = logs.map(value => value.args.badgeId);

        // Badge in block valid
        expect(badges.length)
            .to.be.equals(2);

        // 2.1 Test Event Badge
        describe("2.1 - Test Event Badge", function () {

            it("2.1.1 - Verify Event Badge", async function () {
                // Verify student1
                const [isValid1, earnedAt1] = await courseBadge.read.verifyBadge([
                    student1.address, badges[0]!
                ]);

                // Verify student2
                const [isValid2, earnedAt2] = await courseBadge.read.verifyBadge([
                    student2.address, badges[1]!
                ]);

                // Either Badge Valid
                expect(isValid1)
                    .to.be.true;

                expect(isValid2)
                    .to.be.true;

            })

            it("2.1.2 - Assert Student Badge", async function () {
                const student1Badge = await courseBadge.read.getStudentBadges([
                    student1.address
                ]);

                const student2Badge = await courseBadge.read.getStudentBadges([
                    student2.address
                ]);

                expect(student1Badge[0])
                    .to.be.equals(badges[0]);

                expect(student2Badge[0])
                    .to.be.equals(badges[1]);
            })

        })

    });

    // 3.0 Grant Achievement
    it("3.0 - Grant Achievement", async function () {

        const achievementName = "NOLEP";
        const trx1Hash = await courseBadge.write.grantAchievement([
            student1.address, achievementName, BigInt(3)
        ]);
        const trx2Hash = await courseBadge.write.grantAchievement([
            student2.address, achievementName, BigInt(3)
        ]);

        // Get Receipt
        const trx1Receipt = await testClient.getTransactionReceipt({
            hash: trx1Hash
        });
        const trx2Receipt = await testClient.getTransactionReceipt({
            hash: trx2Hash
        });


        // 3.1 Test Event Badge
        describe("3.1 - Test Grant Achievement", function () {

            it("3.1.1 - Assert Grant Achievement", async function () {

                const abiGrantAchievement = 'event GrantAchievement(address indexed student,string indexed achievementNameIndex,string achievementName,uint256 achievementId,uint256 rarity)';

                // Get Log Student 1
                const logsStudent1 = await testClient.getLogs({
                    event: parseAbiItem(abiGrantAchievement),
                    blockHash: trx1Receipt.blockHash,
                    args: {
                        student: [student1.address],
                        achievementNameIndex: achievementName
                    }
                });

                // Get Log Student 2
                const logsStudent2 = await testClient.getLogs({
                    event: parseAbiItem(abiGrantAchievement),
                    blockHash: trx2Receipt.blockHash,
                    args: {
                        student: [student2.address],
                        achievementNameIndex: achievementName
                    }
                });

                expect((logsStudent1[0].args.student as string).toLowerCase())
                    .to.be.equals(student1.address);

                expect((logsStudent2[0].args.student as string).toLowerCase())
                    .to.be.equals(student2.address);
            })
        })

    })

    // 4.0 Grant Achievement
    it("4.0 - Workshop Series", async function () {

        const seriesName = "BlockDev Kelas Rutin Batch2";

        const trxHash = await courseBadge.write.createWorkshopSeries([
            seriesName, BigInt(12)
        ]);

        // Get Receipt
        const trxReceipt = await testClient.getTransactionReceipt({
            hash: trxHash
        });

        // 4.1 Test Event Badge
        describe("4.1 - Test  Workshop Series", function () {

            it("4.1.1 - Assert  Workshop Series", async function () {

                // Get Log
                const logs = await testClient.getLogs({
                    event: parseAbiItem('event CreateWorkshopSeries(string indexed seriesNameIndex,string seriesName,uint256 totalSessions,uint256[] tokens)'),
                    blockHash: trxReceipt.blockHash,
                    args: {
                        seriesNameIndex: seriesName
                    }
                });

                const logArgs = logs.map(val => val.args)[0]!;

                // Verify
                expect(logArgs.seriesName)
                    .to.be.equals(seriesName);
                expect(logArgs.totalSessions)
                    .to.be.equals(BigInt(12));
                expect(logArgs.tokens?.length)
                    .to.be.equals(12);

            })
        })

    })

});
