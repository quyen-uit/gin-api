-- ### PRODUCT_BRANDS ###

-- name: GetProductBrand :one
SELECT * FROM product_brands
WHERE id = $1 LIMIT 1;

-- name: ListProductBrands :many
SELECT * FROM product_brands
ORDER BY name
LIMIT $1 OFFSET $2;

-- name: CreateProductBrand :one
INSERT INTO product_brands (
  name,
  country,
  picture,
  description
) VALUES (
  $1, $2, $3, $4
)
RETURNING *;

-- name: UpdateProductBrand :one
UPDATE product_brands
SET
  name = $2,
  country = $3,
  picture = $4,
  description = $5
WHERE id = $1
RETURNING *;

-- name: DeleteProductBrand :exec
DELETE FROM product_brands
WHERE id = $1;