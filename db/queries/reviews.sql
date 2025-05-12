-- ### REVIEWS ###

-- name: GetReview :one
SELECT * FROM reviews
WHERE id = $1 LIMIT 1;

-- name: ListReviewsByProductID :many
SELECT r.*, c.first_name as user_first_name, c.last_name as user_last_name
FROM reviews r
JOIN users c ON r.user_id = c.id
WHERE r.product_id = $1
ORDER BY r.created_at DESC
LIMIT $2 OFFSET $3;

-- name: ListReviewsByUserID :many
SELECT r.*, p.name as product_name
FROM reviews r
JOIN products p ON r.product_id = p.id
WHERE r.user_id = $1
ORDER BY r.created_at DESC
LIMIT $2 OFFSET $3;

-- name: ListReviews :many
SELECT r.*, p.name as product_name
FROM reviews r
JOIN products p ON r.product_id = p.id
ORDER BY r.created_at DESC
LIMIT $1 OFFSET $2;

-- name: CreateReview :one
INSERT INTO reviews (
  product_id,
  user_id,
  rating,
  comment
) VALUES (
  $1, $2, $3, $4
)
RETURNING *;

-- name: UpdateReview :one
UPDATE reviews
SET
  rating = $2,
  comment = $3
WHERE id = $1 AND user_id = $4 -- Ensure user can only update their own review
RETURNING *;

-- name: DeleteReview :exec
DELETE FROM reviews
WHERE id = $1 AND user_id = $2; -- Ensure user can only delete their own review