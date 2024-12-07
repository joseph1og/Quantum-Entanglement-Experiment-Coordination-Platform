;; quantum-token contract

(define-fungible-token quantum-token)

(define-constant contract-owner tx-sender)

(define-constant token-name "Quantum Token")
(define-constant token-symbol "QT")

(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err u403))
    (ft-mint? quantum-token amount recipient)
  )
)

(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) (err u403))
    (ft-transfer? quantum-token amount sender recipient)
  )
)

(define-read-only (get-name)
  (ok token-name)
)

(define-read-only (get-symbol)
  (ok token-symbol)
)

(define-read-only (get-balance (account principal))
  (ok (ft-get-balance quantum-token account))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply quantum-token))
)

