;; experiment-coordination contract

(define-map experiments
  { experiment-id: uint }
  {
    creator: principal,
    participants: (list 10 principal),
    start-time: uint,
    duration: uint,
    status: (string-ascii 20)
  }
)

(define-data-var last-experiment-id uint u0)

(define-constant contract-owner tx-sender)

(define-public (create-experiment (participants (list 10 principal)) (start-time uint) (duration uint))
  (let
    (
      (experiment-id (+ (var-get last-experiment-id) u1))
    )
    (asserts! (> start-time block-height) (err u400))
    (asserts! (> duration u0) (err u401))
    (map-set experiments
      { experiment-id: experiment-id }
      {
        creator: tx-sender,
        participants: participants,
        start-time: start-time,
        duration: duration,
        status: "scheduled"
      }
    )
    (var-set last-experiment-id experiment-id)
    (ok experiment-id)
  )
)

(define-public (start-experiment (experiment-id uint))
  (let
    (
      (experiment (unwrap! (map-get? experiments { experiment-id: experiment-id }) (err u404)))
    )
    (asserts! (is-eq (get creator experiment) tx-sender) (err u403))
    (asserts! (is-eq (get status experiment) "scheduled") (err u402))
    (asserts! (>= block-height (get start-time experiment)) (err u405))
    (map-set experiments
      { experiment-id: experiment-id }
      (merge experiment { status: "in-progress" })
    )
    (ok true)
  )
)

(define-public (complete-experiment (experiment-id uint))
  (let
    (
      (experiment (unwrap! (map-get? experiments { experiment-id: experiment-id }) (err u404)))
    )
    (asserts! (is-eq (get creator experiment) tx-sender) (err u403))
    (asserts! (is-eq (get status experiment) "in-progress") (err u402))
    (asserts! (>= block-height (+ (get start-time experiment) (get duration experiment))) (err u405))
    (map-set experiments
      { experiment-id: experiment-id }
      (merge experiment { status: "completed" })
    )
    (ok true)
  )
)

(define-read-only (get-experiment (experiment-id uint))
  (map-get? experiments { experiment-id: experiment-id })
)

