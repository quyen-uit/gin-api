-- ### RETURN_ORDER_ITEMS ###

-- name: GetReturnOrderItem :one
SELECT * FROM return_order_items
WHERE id = $1 LIMIT 1;

-- name: ListReturnOrderItemsByReturnOrderID :many
SELECT roi.*, ps.sku_code
FROM return_order_items roi
JOIN product_skus ps ON roi.sku_id = ps.id
WHERE roi.return_order_id = $1
ORDER BY roi.id;

-- name: CreateReturnOrderItem :one
INSERT INTO return_order_items (
  return_order_id,
  sku_id,
  quantity,
  price,
  amount
) VALUES (
  $1, $2, $3, $4, $5
)
RETURNING *;

-- name: UpdateReturnOrderItem :one
UPDATE return_order_items
SET
  quantity = $2,
  price = $3,
  amount = $4
WHERE id = $1
RETURNING *;

-- name: DeleteReturnOrderItem :exec
DELETE FROM return_order_items
WHERE id = $1;