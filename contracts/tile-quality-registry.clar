;; TileChain Quality Registry
;; A contract for tracking ceramic tile quality certifications and authenticity

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-exists (err u102))
(define-constant err-invalid-rating (err u103))

(define-map tile-registry
  { tile-id: uint }
  {
    manufacturer: principal,
    batch-number: (string-ascii 20),
    quality-rating: uint,
    certification-date: uint,
    inspector: principal,
    is-authentic: bool
  }
)

(define-map manufacturer-approved
  { manufacturer: principal }
  { approved: bool }
)

(define-data-var next-tile-id uint u1)

;; Register a new ceramic tile with quality certification
(define-public (register-tile 
  (manufacturer principal)
  (batch-number (string-ascii 20))
  (quality-rating uint)
  (inspector principal))
  (let ((tile-id (var-get next-tile-id)))
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (and (>= quality-rating u1) (<= quality-rating u10)) err-invalid-rating)
    (asserts! (is-none (map-get? tile-registry { tile-id: tile-id })) err-already-exists)
    (map-set tile-registry
      { tile-id: tile-id }
      {
        manufacturer: manufacturer,
        batch-number: batch-number,
        quality-rating: quality-rating,
        certification-date: stacks-block-height,
        inspector: inspector,
        is-authentic: true
      }
    )
    (var-set next-tile-id (+ tile-id u1))
    (ok tile-id)))

;; Approve manufacturer for quality registry
(define-public (approve-manufacturer (manufacturer principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (map-set manufacturer-approved { manufacturer: manufacturer } { approved: true })
    (ok true)))

;; Get tile information
(define-read-only (get-tile-info (tile-id uint))
  (map-get? tile-registry { tile-id: tile-id }))

;; Verify tile authenticity
(define-read-only (verify-tile-authenticity (tile-id uint))
  (match (map-get? tile-registry { tile-id: tile-id })
    tile-data (ok (get is-authentic tile-data))
    err-not-found))

;; Check if manufacturer is approved
(define-read-only (is-manufacturer-approved (manufacturer principal))
  (default-to false (get approved (map-get? manufacturer-approved { manufacturer: manufacturer }))))

;; Get current tile ID counter
(define-read-only (get-next-tile-id)
  (var-get next-tile-id))