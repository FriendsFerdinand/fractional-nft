

;; regtest
(impl-trait 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.semi-fungible-token-trait.semi-fungible-token-trait)
;; (use-trait  'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.nft-fraction.nft-fraction)
;; ('ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.nft-share.nft-share)
;; end regtest

;; mainnet
(use-trait fungible-token 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE.sip-010-trait-ft-standard.sip-010-trait)
(use-trait non-fungible-token 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.nft-trait.nft-trait)


(define-constant NFT_SYMBOL_CONTRACT 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.nft-symbol)
(define-constant DOES_NOT_OWN_TOKEN_ID u301)
(define-constant UNAUTHORIZED_SENDER u302)
(define-constant NOT_ENOUGH_FUNDS u303)
(define-constant NOT_READY_FOR_DISTRIBUTION u304)

(define-constant SYMBOL_OPENED u0)
(define-constant SYMBOL_BEING_OFFERED u1)
(define-constant SYMBOL_IS_READY_FOR_DISTRIBUTION u2)
(define-constant SYMBOL_IS_DISTRIBUTED u3)

;; fractional-nft
(define-map token-supply {token-id: uint} uint)
(define-map owner-balance {user: principal, token-id: uint} uint)
(define-map symbols {token-id: uint} (string-ascii 10))
(define-map token-ids {symbol: (string-ascii 10)} uint)
(define-map symbol-state (string-ascii 10) uint)
(define-map principal-to-id principal uint)
(define-map id-to-prinicipal uint principal)

;; Get a token type balance of the passed principal
(define-read-only (get-balance (token-id uint) (user principal))
    (ok (default-to u0 (map-get? owner-balance {user: user, token-id: token-id})))
)

(define-read-only (get-symbol (token-id uint))
    (map-get? symbols {token-id: token-id})
)

(define-read-only (get-token-id (symbol (string-ascii 10)))
    (map-get? token-ids {symbol: symbol})
)

;; Get the total SFT balance of the passed principal.
(define-public (get-overall-balance (user principal))
    (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.nft-share get-balance user)
)

;; Get the current total supply of a token type.
(define-read-only (get-total-supply (token-id uint))
    (ok (default-to u0 (map-get? token-supply {token-id: token-id})))
)

;; Get the overall SFT supply.
(define-public (get-overall-supply)
    (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.nft-share get-total-supply)
)

;; Get the number of decimal places of a token type.
(define-read-only (get-decimals (decimals uint))
    (ok u0)
)

;; Get an optional token URI that represents metadata for a specific token.
(define-read-only (get-token-uri (token-id uint))
    (ok none)
)

;; Transfer from one principal to another.
(define-public (transfer (token-id uint) (amount uint) (from principal) (to principal))
    (begin
        (let (
            (from-amount (default-to u0 (map-get? owner-balance {user: tx-sender, token-id: token-id})))
            (to-amount (default-to u0 (map-get? owner-balance {user: to, token-id: token-id})))
            )
            (asserts! (is-eq from tx-sender) (err UNAUTHORIZED_SENDER))
            (asserts! (> from-amount u0) (err DOES_NOT_OWN_TOKEN_ID))
            (asserts! (> amount from-amount) (err NOT_ENOUGH_FUNDS))
            (unwrap-panic
                (contract-call?
                    'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.nft-share
                    transfer
                    amount
                    tx-sender
                    to
                    (some 0x00)
                )
            )
            (map-set
                owner-balance
                { user: tx-sender, token-id: token-id }
                (- from-amount amount)
            )

            (ok
                (map-set
                    owner-balance
                    { user: to, token-id: token-id }
                    (+ to-amount amount)
                )
            )
        )
    )
)

;; Transfer from one principal to another with a memo.
(define-public (transfer-memo (token-id uint) (amount uint) (from principal) (to principal) (memo (buff 34)))
    (begin
        (try! (transfer token-id amount from to))
        (print memo)
        (ok true)
    )
)

(define-private (transfer-many-temp (transaction {token-id: uint, amount: uint, from: principal, to: principal}) (previous-tx (response bool uint)))
    (match previous-tx
        got-ok (transfer
                    (get token-id transaction)
                    (get amount transaction)
                    (get from transaction)
                    (get to transaction)
                )
        got-err previous-tx
    )
)

(define-private (transfer-many-memo-temp (transaction {token-id: uint, amount: uint, from: principal, to: principal, memo: (buff 34)}) (previous-tx (response bool uint)))
    (match previous-tx
        got-ok (transfer-memo
                    (get token-id transaction)
                    (get amount transaction)
                    (get from transaction)
                    (get to transaction)
                    (get memo transaction)
                )
        got-err previous-tx
    )
)

;; Transfer many tokens at once.
(define-public (transfer-many (transfers (list 200 {token-id: uint, amount: uint, from: principal, to: principal})))
    (fold transfer-many-temp transfers (ok true))
)
;; Transfer many tokens at once with memos.
(define-public (transfer-many-memo (recipients (list 200 {token-id: uint, amount: uint, from: principal, to: principal, memo: (buff 34)})))
	(fold transfer-many-memo-temp recipients (ok true))
)

(define-public (mint-all (symbol (string-ascii 10)) (n-shares uint) (symbol-recipient principal) (shares-recipient principal))
    (begin

        (let ((last-id (unwrap-panic (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.nft-symbol get-last-token-id))))
            (unwrap-panic
                (match (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.nft-symbol mint! last-id symbol-recipient)
                    got-ok (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.nft-share mint! n-shares shares-recipient)
                    contract-call-err (err contract-call-err)
                )
            )
            ;; update mapped info
            (map-set token-ids {symbol: symbol} last-id)
            (map-set symbols {token-id: last-id} symbol)
            (map-set
                owner-balance {user: shares-recipient, token-id: last-id}
                (+ (default-to u0 (map-get? owner-balance {user: shares-recipient, token-id: last-id})) n-shares)
            )
            (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.nft-symbol set-last-token-id (+ last-id u1))
        )
    )
)

(define-public (mint-initial (symbol (string-ascii 10)) (n-shares uint) (symbol-recipient principal))
    (begin
        (mint-all symbol n-shares symbol-recipient (as-contract tx-sender))
    )
)
