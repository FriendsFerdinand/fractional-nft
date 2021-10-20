(impl-trait 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE.sip-010-trait-ft-standard.sip-010-trait)

;; nft-share
(define-fungible-token nft-share)

;; get the token balance of owner
(define-read-only (get-balance (owner principal))
  (ok (ft-get-balance nft-share owner))
)

;; returns the total number of tokens
(define-read-only (get-total-supply)
  (ok (ft-get-supply nft-share))
)

;; returns the token name
(define-read-only (get-name)
  (ok "NFT Share")
)

;; the symbol or "ticker" for this token
(define-read-only (get-symbol)
  (ok "NF")
)

;; the number of decimals used
(define-read-only (get-decimals)
  (ok u0)
)

;; Transfers tokens to a recipient
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
      (try! (ft-transfer? nft-share amount sender recipient))
      (print memo)
      (ok true)
  )
)

(define-public (mint! (amount uint) (recipient principal))
  (ft-mint? nft-share amount recipient)   
)

(define-public (get-token-uri)
  (ok (some u"https://nft-symbol.com/nft-share.json"))
)
