-- name: GetCategory :one
SELECT * FROM categories
WHERE id = $1 LIMIT 1;

-- name: ListCategories :many
SELECT * FROM categories
ORDER BY name;

-- name: CreateCategory :one
INSERT INTO categories (
  name,
  parent_id,
  display_order,
  is_active
) VALUES (
  $1, $2, $3, $4
)
RETURNING *;

-- name: UpdateCategory :one
UPDATE categories
SET
  name = $2,
  parent_id = $3,
  display_order = $4,
  is_active = $5
WHERE id = $1
RETURNING *;

-- name: DeleteCategory :exec
DELETE FROM categories
WHERE id = $1;
