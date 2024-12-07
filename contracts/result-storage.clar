;; result-storage contract

(define-map results
  { result-id: uint }
  {
    experiment-id: uint,
    researcher: principal,
    data-hash: (buff 32),
    timestamp: uint
  }
)

(define-data-var last-result-id uint u0)

(define-public (store-result (experiment-id uint) (data-hash (buff 32)))
  (let
    (
      (result-id (+ (var-get last-result-id) u1))
    )
    (map-set results
      { result-id: result-id }
      {
        experiment-id: experiment-id,
        researcher: tx-sender,
        data-hash: data-hash,
        timestamp: block-height
      }
    )
    (var-set last-result-id result-id)
    (ok result-id)
  )
)

(define-read-only (get-result (result-id uint))
  (map-get? results { result-id: result-id })
)

