
(impl-trait 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.nft-trait.nft-trait)

;; nft-symbol
(define-non-fungible-token nft-symbol uint)

(define-data-var last-id uint u0)

(define-read-only (get-owner (token-id uint))
  (ok (nft-get-owner? nft-symbol token-id))
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
    (nft-transfer? nft-symbol token-id sender recipient)
)

(define-read-only (get-last-token-id)
  (ok (var-get last-id))
)

(define-public (set-last-token-id (token-id uint))
  (ok (var-set last-id token-id))
)

(define-read-only (get-contract-metadata)
  (ok (some "https://nft-symbol.com/metadata.json"))
)

(define-read-only (get-token-uri (token-id uint))
  (ok (some "https://nft-symbol.com/uri.json"))
)

(define-public (mint! (token-id uint) (recipient principal))
  (nft-mint? nft-symbol token-id recipient)
)