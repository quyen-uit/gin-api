-- ### WISHLISTS ###

-- name: GetWishlistItemByID :one
SELECT * FROM wishlists
WHERE id = $1 LIMIT 1;

-- name: ListWishlistItemsByUser :many
SELECT sqlc.embed(w), sqlc.embed(p)
FROM wishlists w
JOIN products p ON w.product_id = p.id
WHERE w.user_id = $1
ORDER BY w.created_at DESC
LIMIT $2 OFFSET $3;



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
