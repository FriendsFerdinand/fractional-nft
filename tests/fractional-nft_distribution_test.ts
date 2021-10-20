
import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v0.14.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
    name: "Ensure that NFT shares are distributed to investors",
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
    name: "Ensure that NFT is sent to owner and shares are distributed",
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
        ]);
        assertEquals(block.height, 2);

        let assetMaps = chain.getAssetsMaps();
    },
});
