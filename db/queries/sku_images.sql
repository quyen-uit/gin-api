-- ### SKU_IMAGES ###

-- name: GetSkuImage :one
SELECT * FROM sku_images
WHERE id = $1 LIMIT 1;

-- name: ListSkuImagesBySkuID :many
SELECT * FROM sku_images
WHERE sku_id = $1
ORDER BY id
LIMIT $2 OFFSET $3;

-- name: CreateSkuImage :one
INSERT INTO sku_images (
  sku_id,
  image_url,
  display_order
) VALUES (
  $1, $2, $3
)
RETURNING *;

-- name: DeleteSkuImage :exec
DELETE FROM sku_images
WHERE id = $1;

-- name: DeleteSkuImagesBySkuID :exec
DELETE FROM sku_images
WHERE sku_id = $1;