-- ### CARTS ###

-- name: GetCart :one
SELECT * FROM carts
WHERE id = $1 LIMIT 1;

-- name: GetActiveCartByCustomerID :one
SELECT * FROM carts
WHERE customer_id = $1 AND status = 'active' -- Assuming 'active' is a status, adjust if necessary
LIMIT 1;

-- name: ListCartsByCustomerID :many
SELECT * FROM carts
WHERE customer_id = $1
ORDER BY created_at DESC;

-- name: CreateCart :one
INSERT INTO carts (
  customer_id,
  status
) VALUES (
  $1, $2
)
RETURNING *;

-- name: UpdateCartStatus :one
UPDATE carts
SET
  status = $2
WHERE id = $1
RETURNING *;

-- name: DeleteCart :exec
DELETE FROM carts
WHERE id = $1;