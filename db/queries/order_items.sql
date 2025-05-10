-- ### ORDER_ITEMS ###

-- name: GetOrderItem :one
SELECT * FROM order_items
WHERE id = $1 LIMIT 1;

-- name: ListOrderItemsByOrderID :many
SELECT oi.*, ps.sku_code, p.name as product_name
FROM order_items oi
JOIN product_skus ps ON oi.sku_id = ps.id
JOIN products p ON ps.product_id = p.id
WHERE oi.order_id = $1
ORDER BY p.name;

-- name: CreateOrderItem :one
INSERT INTO order_items (
  order_id,
  sku_id,
  quantity,
  price,
  amount
) VALUES (
  $1, $2, $3, $4, $5
)
RETURNING *;

-- name: UpdateOrderItem :one
UPDATE order_items
SET
  quantity = $2,
  price = $3,
  amount = $4
WHERE id = $1
RETURNING *;

-- name: DeleteOrderItem :exec
DELETE FROM order_items
WHERE id = $1;