-- ### SIZES ###

-- name: GetSize :one
SELECT * FROM sizes
WHERE id = $1 LIMIT 1;

-- name: ListSizes :many
SELECT * FROM sizes
ORDER BY name;

-- name: CreateSize :one
INSERT INTO sizes (
  name
) VALUES (
  $1
)
RETURNING *;

-- name: UpdateSize :one
UPDATE sizes
SET
  name = $2
WHERE id = $1
RETURNING *;

-- name: DeleteSize :exec
DELETE FROM sizes
WHERE id = $1;