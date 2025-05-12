-- ### RETURN_ORDERS ###

-- name: GetReturnOrder :one
SELECT * FROM return_orders
WHERE id = $1 LIMIT 1;

-- name: ListReturnOrders :many
SELECT * FROM return_orders
ORDER BY return_date DESC
LIMIT $1 OFFSET $2;

-- name: ListReturnOrdersByUserID :many
SELECT * FROM return_orders
WHERE user_id = $1
ORDER BY return_date DESC
LIMIT $2 OFFSET $3;

-- name: CreateReturnOrder :one
INSERT INTO return_orders (
  order_id,
  return_date,
  reason,
  status,
  notes,
  total_amount,
  user_id
) VALUES (
  $1, $2, $3, $4, $5, $6, $7
)
RETURNING *;

-- name: UpdateReturnOrderStatus :one
UPDATE return_orders
SET
  status = $2,
  notes = $3,
  total_amount = $4
WHERE id = $1
RETURNING *;

-- name: DeleteReturnOrder :exec
DELETE FROM return_orders
WHERE id = $1; -- Use with caution