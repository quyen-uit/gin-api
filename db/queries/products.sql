-- ### PRODUCTS ###

-- name: GetProduct :one
SELECT * FROM products
WHERE id = $1 LIMIT 1;

-- name: ListProducts :many
SELECT * FROM products
WHERE is_active = $1 OR $1 IS NULL
ORDER BY name
LIMIT $2 OFFSET $3;

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
WHERE category_id = $1 AND (is_active = $2 OR $2 IS NULL)
ORDER BY name
LIMIT $3 OFFSET $4;

-- name: ListProductsByBrand :many
SELECT * FROM products
WHERE brand_id = $1 AND (is_active = $2 OR $2 IS NULL)
ORDER BY name
LIMIT $3 OFFSET $4;

-- name: ListNewProducts :many
SELECT * FROM products
WHERE is_new = TRUE AND (is_active = $2 OR $2 IS NULL)
ORDER BY name
LIMIT $3 OFFSET $4;

-- name: ListTrendingProducts :many
SELECT * FROM products
WHERE is_trending = TRUE AND (is_active = $2 OR $2 IS NULL)
ORDER BY name
LIMIT $3 OFFSET $4;

-- name: SearchProducts :many
SELECT * FROM products
WHERE name ILIKE $1 AND (is_active = $2 OR $2 IS NULL)
ORDER BY name
LIMIT $3 OFFSET $4;