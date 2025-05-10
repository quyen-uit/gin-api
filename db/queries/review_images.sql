-- ### REVIEW_IMAGES ###

-- name: GetReviewImage :one
SELECT * FROM review_images
WHERE id = $1 LIMIT 1;

-- name: ListReviewImagesByReviewID :many
SELECT * FROM review_images
WHERE review_id = $1
ORDER BY id;

-- name: CreateReviewImage :one
INSERT INTO review_images (
  review_id,
  image_url
) VALUES (
  $1, $2
)
RETURNING *;

-- name: DeleteReviewImage :exec
DELETE FROM review_images
WHERE id = $1;

-- name: DeleteReviewImagesByReviewID :exec
DELETE FROM review_images
WHERE review_id = $1;