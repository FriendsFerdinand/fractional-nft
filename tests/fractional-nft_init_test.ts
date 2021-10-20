
import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v0.14.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
    name: "Ensure that only deployed contract initializes NFTs and NFT Shares",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        let deployerWallet = accounts.get("deployer") as Account;
        let wallet1 = accounts.get("wallet_1") as Account;
        let wallet2 = accounts.get("wallet_2") as Account;

        let block = chain.mineBlock([
            Tx.contractCall(
                `fractional-nft`,
                "mint-single",
                [types.ascii("HEY"), types.uint(100), types.principal(deployerWallet.address)],
                deployerWallet.address
            ),
            Tx.contractCall(
                `fractional-nft`,
                "transfer",
                [types.uint(0), types.uint(40), types.principal(deployerWallet.address), types.principal(wallet1.address)],
                deployerWallet.address
            ),
            Tx.contractCall(
                `fractional-nft`,
                "transfer",
                [types.uint(0), types.uint(40), types.principal(deployerWallet.address), types.principal(wallet2.address)],
                deployerWallet.address
            ),
            Tx.contractCall(
                `fractional-nft`,
                "get-balance",
                [types.uint(0), types.principal(deployerWallet.address)],
                deployerWallet.address
            ),
        ]);
        // assertEquals(block.receipts.length, 3);
        // console.log(block.receipts[3]);
        assertEquals(block.height, 2);

        let assetMaps = chain.getAssetsMaps();
        // console.log(assetMaps);

        block = chain.mineBlock([
            /* 
             * Add transactions with: 
             * Tx.contractCall(...)
            */
        ]);
        assertEquals(block.receipts.length, 0);
        assertEquals(block.height, 3);
    },
});

Clarinet.test({
    name: "Ensure that users can create NFT and NFT shares",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        let deployerWallet = accounts.get("deployer") as Account;
        let wallet1 = accounts.get("wallet_1") as Account;
        let wallet2 = accounts.get("wallet_2") as Account;

        let block = chain.mineBlock([
            // Tx.contractCall(
            //     `fractional-nft`,
            //     "mint-single",
            //     [types.ascii("HEY"), types.uint(100), types.principal(deployerWallet.address)],
            //     deployerWallet.address
            // ),
        ]);
        assertEquals(block.height, 2);

    },
});


Clarinet.test({
    name: "Ensure that users can transfer NFTs and NFT shares",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        let deployerWallet = accounts.get("deployer") as Account;
        let wallet1 = accounts.get("wallet_1") as Account;
        let wallet2 = accounts.get("wallet_2") as Account;

        let block = chain.mineBlock([
            // Tx.contractCall(
            //     `fractional-nft`,
            //     "mint-single",
            //     [types.ascii("HEY"), types.uint(100), types.principal(deployerWallet.address)],
            //     deployerWallet.address
            // ),
        ]);
        assertEquals(block.height, 2);

    },
});


Clarinet.test({
    name: "Ensure that users can display NFT and NFT share metadata",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        let deployerWallet = accounts.get("deployer") as Account;
        let wallet1 = accounts.get("wallet_1") as Account;
        let wallet2 = accounts.get("wallet_2") as Account;

        let block = chain.mineBlock([
            // Tx.contractCall(
            //     `fractional-nft`,
            //     "mint-single",
            //     [types.ascii("HEY"), types.uint(100), types.principal(deployerWallet.address)],
            //     deployerWallet.address
            // ),
        ]);
        assertEquals(block.height, 2);

    },
});