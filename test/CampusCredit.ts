import {expect} from "chai";
import {after, before, it} from "mocha";
import hre from "hardhat";
import {publicActions, walletActions} from "viem";

describe("CampusCredit", function () {

    // Main Component
    const testClientTyped = async (account: `0x${string}`) => (await hre.viem.getTestClient({
        account: account
    }))
        .extend(publicActions).extend(walletActions);

    const walletClientsTyped = async () => (await hre.viem.getWalletClients());
    const campusCreditTyped = async () => (await hre.viem.deployContract("CampusCredit", [], {}));

    let testClient: Awaited<ReturnType<typeof testClientTyped>>;
    let walletClients: Awaited<ReturnType<typeof walletClientsTyped>>;
    let campusCredit: Awaited<ReturnType<typeof campusCreditTyped>>;

    // Testing Component
    type TestAccount = (typeof walletClients extends (infer U)[] ? U : never)['account'];

    let accountExecutor: TestAccount;
    let student1: TestAccount;
    let student2: TestAccount;
    let merchant: TestAccount;

    // SetUp
    before(async () => {
        walletClients = await walletClientsTyped()
        const [owner, acc1, acc2, acc3] = walletClients;
        accountExecutor = owner.account;
        student1 = acc1.account;
        student2 = acc2.account;
        merchant = acc3.account;

        testClient = await testClientTyped(accountExecutor.address)
        campusCredit = await campusCreditTyped()
    })

    // Tear Down
    after(() => {
        console.log("Test Finish");
    });


    // ==========

    // 1.0 Minting Credit
    it("1.0 - Minting Credit", async function () {

        await expect(campusCredit.write.mint([
            student1.address,
            BigInt(1000)
        ])).to.be.fulfilled;

        const query1 = await campusCredit.read.balanceOf([
            student1.address
        ]);

        expect(query1).to.be.equals(BigInt(1000));


    });

    // 2.0 Register Merchant
    it("2.0 - Check", async function () {

        await expect(campusCredit.write.registerMerchant([
            merchant.address,
            "BlockDevID"
        ])).to.be.fulfilled;

        const query1 = await campusCredit.read.merchantName([
            merchant.address
        ]);
        const query2 = await campusCredit.read.isMerchant([
            merchant.address
        ]);

        expect(query1).to.be.equals("BlockDevID");
        expect(query2).to.be.true;
    });

    // 3.0 Set Daily Limit
    it("3.0 - Set Daily Limit", async function () {

        await expect(campusCredit.write.setDailyLimit([
            student1.address,
            BigInt(900)
        ])).to.be.fulfilled;

        const query1 = await campusCredit.read.dailySpendingLimit([
            student1.address
        ]);

        expect(query1).to.be.equals(BigInt(900));
    });

    // 4.0 Do Transfer Limit
    it("4.0 - Transfer Limit", async function () {

        // 1000 - 100 = 900
        await expect(campusCredit.write.transferWithLimit([
            student2.address,
            BigInt(100)
        ], {
            account: student1
        })).to.be.fulfilled;

        const balanceFriend = await campusCredit.read.balanceOf([
            student2.address
        ]);

        expect(balanceFriend).to.be.equals(BigInt(100));
    });

    // 5.0 Do Transfer Cashback
    it("4.0 - Transfer Limit", async function () {

        const balanceStudentBefore = await campusCredit.read.balanceOf([
            student1.address
        ]);

        const trx = await campusCredit.write.transferWithCashback([
            merchant.address,
            BigInt(100)
        ], {
            account: student1
        });
        // 900 - 100 = 800
        // await expect(trx).to.be.fulfilled;


        const balanceStudentAfter = await campusCredit.read.balanceOf([
            student1.address
        ]);

        const balanceMerchantAfter = await campusCredit.read.balanceOf([
            merchant.address
        ]);

        console.log({
            balanceStudentBefore,
            balanceStudentAfter,
            balanceMerchantAfter
        })

        expect(balanceStudentBefore)
            .to.be.equals(BigInt(900));

        expect(balanceStudentAfter)
            .to.be.equals(BigInt(900 - 100));

        expect(balanceMerchantAfter)
            .to.be.equals(BigInt(100));
    });

});
