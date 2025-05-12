-- ### CARTS ###

-- name: GetCart :one
SELECT * FROM carts
WHERE id = $1 LIMIT 1;

-- name: ListCarts :many
SELECT * FROM carts
ORDER BY created_at DESC
LIMIT $1 OFFSET $2;

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