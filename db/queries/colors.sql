-- ### COLORS ###

-- name: GetColor :one
SELECT * FROM colors
WHERE id = $1 LIMIT 1;

-- name: ListColors :many
SELECT * FROM colors
ORDER BY name
LIMIT $1 OFFSET $2;

-- name: CreateColor :one
INSERT INTO colors (
  name,
  hex_code
) VALUES (
  $1, $2
)
RETURNING *;

-- name: UpdateColor :one
UPDATE colors
SET
  name = $2,
  hex_code = $3
WHERE id = $1
RETURNING *;

-- name: DeleteColor :exec
DELETE FROM colors
WHERE id = $1;