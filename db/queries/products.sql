-- ### PRODUCTS ###

-- name: GetProduct :one
SELECT * FROM products
WHERE id = $1 LIMIT 1;

-- name: ListProducts :many
SELECT * FROM products
WHERE is_active = TRUE
ORDER BY name;

-- name: CreateProduct :one
INSERT INTO products (
  name,
  description,
  category_id,
  is_new,
  is_trending,
  is_active,
  thumbnail,
  brand_id,
  properties
) VALUES (
  $1, $2, $3, $4, $5, $6, $7, $8, $9
)
RETURNING *;

-- name: UpdateProduct :one
UPDATE products
SET
  name = $2,
  description = $3,
  category_id = $4,
  is_new = $5,
  is_trending = $6,
  is_active = $7,
  thumbnail = $8,
  brand_id = $9,
  properties = $10
WHERE id = $1
RETURNING *;

-- name: DeleteProduct :exec
DELETE FROM products
WHERE id = $1;

-- name: ListProductsByCategory :many
SELECT * FROM products
WHERE category_id = $1 AND is_active = TRUE
ORDER BY name;

-- name: ListProductsByBrand :many
SELECT * FROM products
WHERE brand_id = $1 AND is_active = TRUE
ORDER BY name;

-- name: ListNewProducts :many
SELECT * FROM products
WHERE is_new = TRUE AND is_active = TRUE
ORDER BY name;

-- name: ListTrendingProducts :many
SELECT * FROM products
WHERE is_trending = TRUE AND is_active = TRUE
ORDER BY name;

-- name: SearchProducts :many
SELECT * FROM products
WHERE is_active = TRUE AND (name ILIKE $1 OR description ILIKE $1)
ORDER BY name;