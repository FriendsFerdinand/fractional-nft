
;; testnet
(use-trait sft-trait 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.semi-fungible-token-trait.semi-fungible-token-trait)
(define-constant SFT_CONTRACT 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.fractional-nft)



(define-public (mint-symbol (symbol(string-ascii 10) (n-shares uint) (creator principal)))
    (contract-call? SFT_CONTRACT mint-initial symbol n-shares)
)

(define-public (claim-shares (symbol (string-ascii 10)) (claimer principal))
    (begin
        (asserts! (is-eq (unwrap-panic (map-get? symbol-state symbol)) SYMBOL_IS_READY_FOR_DISTRIBUTION) (err NOT_READY_FOR_DISTRIBUTION))
        (map-set symbol-state symbol SYMBOL_IS_DISTRIBUTED)
        (ok true)
    )
)
