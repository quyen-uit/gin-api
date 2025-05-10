-- ### WISHLISTS ###

-- name: GetWishlistItemByID :one
SELECT * FROM wishlists
WHERE id = $1 LIMIT 1;

-- name: ListWishlistItemsByUser :many
SELECT w.*, p.name as product_name, p.thumbnail as product_thumbnail
FROM wishlists w
JOIN products p ON w.product_id = p.id
WHERE w.user_id = $1
ORDER BY w.created_at DESC;

-- name: AddProductToWishlist :one
INSERT INTO wishlists (
  user_id,
  product_id
) VALUES (
  $1, $2
)
RETURNING *;

-- name: RemoveProductFromWishlist :exec
DELETE FROM wishlists
WHERE user_id = $1 AND product_id = $2;

-- name: GetWishlistItemByUserAndProduct :one
SELECT * FROM wishlists
WHERE user_id = $1 AND product_id = $2
LIMIT 1;