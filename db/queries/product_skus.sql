-- ### PRODUCT_SKUS ###

-- name: GetProductSku :one
SELECT * FROM product_skus
WHERE id = $1 LIMIT 1;

-- name: GetProductSkuByCode :one
SELECT * FROM product_skus
WHERE sku_code = $1 LIMIT 1;

-- name: ListProductSkus :many
SELECT * FROM product_skus
ORDER BY sku_code;

-- name: ListProductSkusByProductID :many
SELECT ps.*, c.name as color_name, s.name as size_name
FROM product_skus ps
LEFT JOIN colors c ON ps.color_id = c.id
LEFT JOIN sizes s ON ps.size_id = s.id
WHERE ps.product_id = $1 AND ps.is_active = TRUE
ORDER BY c.name, s.name;

-- name: CreateProductSku :one
INSERT INTO product_skus (
  product_id,
  sku_code,
  price,
  is_active,
  color_id,
  size_id
) VALUES (
  $1, $2, $3, $4, $5, $6
)
RETURNING *;

-- name: UpdateProductSku :one
UPDATE product_skus
SET
  product_id = $2,
  sku_code = $3,
  price = $4,
  is_active = $5,
  color_id = $6,
  size_id = $7
WHERE id = $1
RETURNING *;

-- name: DeleteProductSku :exec
DELETE FROM product_skus
WHERE id = $1;