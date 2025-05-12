-- ### CART_ITEMS ###

-- name: GetCartItem :one
SELECT * FROM cart_items
WHERE id = $1 LIMIT 1;

-- name: ListCartItemsByCartID :many
SELECT ci.*, ps.sku_code, p.name as product_name, p.thumbnail as product_thumbnail, ps.price as sku_price
FROM cart_items ci
JOIN product_skus ps ON ci.sku_id = ps.id
JOIN products p ON ps.product_id = p.id
WHERE ci.cart_id = $1
ORDER BY ci.id
LIMIT $2 OFFSET $3;

-- name: CreateCartItem :one
INSERT INTO cart_items (
  cart_id,
  sku_id,
  quantity,
  price,
  amount
) VALUES (
  $1, $2, $3, $4, $5
)
RETURNING *;

-- name: UpdateCartItemQuantity :one
UPDATE cart_items
SET
  quantity = $2,
  amount = $3
WHERE id = $1
RETURNING *;

-- name: DeleteCartItem :exec
DELETE FROM cart_items
WHERE id = $1;

-- name: ClearCartItems :exec
DELETE FROM cart_items
WHERE cart_id = $1;