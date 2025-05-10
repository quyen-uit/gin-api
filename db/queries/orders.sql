-- ### ORDERS ###

-- name: GetOrder :one
SELECT * FROM orders
WHERE id = $1 LIMIT 1;

-- name: ListOrders :many
SELECT * FROM orders
ORDER BY order_date DESC;

-- name: ListOrdersByCustomer :many
SELECT * FROM orders
WHERE customer_id = $1
ORDER BY order_date DESC;

-- name: CreateOrder :one
INSERT INTO orders (
  customer_id,
  order_date,
  total_amount,
  status,
  notes,
  shipping_type,
  payment_type,
  address
) VALUES (
  $1, $2, $3, $4, $5, $6, $7, $8
)
RETURNING *;

-- name: UpdateOrderStatus :one
UPDATE orders
SET
  status = $2
WHERE id = $1
RETURNING *;

-- name: UpdateOrderDetails :one
UPDATE orders
SET
  total_amount = $2,
  notes = $3,
  shipping_type = $4,
  payment_type = $5,
  address = $6
WHERE id = $1
RETURNING *;

-- name: DeleteOrder :exec
DELETE FROM orders
WHERE id = $1; -- Use with caution, often orders are cancelled (status change) not deleted