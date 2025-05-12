-- ### VENDORS ###

-- name: GetVendor :one
SELECT * FROM vendors
WHERE id = $1 LIMIT 1;

-- name: ListVendors :many
SELECT * FROM vendors
ORDER BY name
LIMIT $1 OFFSET $2;

-- name: CreateVendor :one
INSERT INTO vendors (
  name,
  phone,
  address,
  email
) VALUES (
  $1, $2, $3, $4
)
RETURNING *;

-- name: UpdateVendor :one
UPDATE vendors
SET
  name = $2,
  phone = $3,
  address = $4,
  email = $5
WHERE id = $1
RETURNING *;

-- name: DeleteVendor :exec
DELETE FROM vendors
WHERE id = $1;