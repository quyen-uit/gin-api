-- ### PRICE_ADJUSTMENTS ###

-- name: GetPriceAdjustment :one
SELECT * FROM price_adjustments
WHERE id = $1 LIMIT 1;

-- name: ListPriceAdjustmentsBySkuID :many
SELECT * FROM price_adjustments
WHERE sku_id = $1
ORDER BY start_date DESC;

-- name: ListActivePriceAdjustmentsBySkuID :many
SELECT * FROM price_adjustments
WHERE sku_id = $1 AND start_date <= NOW() AND end_date >= NOW()
ORDER BY start_date DESC;

-- name: CreatePriceAdjustment :one
INSERT INTO price_adjustments (
  sku_id,
  start_date,
  end_date,
  sale_price
) VALUES (
  $1, $2, $3, $4
)
RETURNING *;

-- name: UpdatePriceAdjustment :one
UPDATE price_adjustments
SET
  sku_id = $2,
  start_date = $3,
  end_date = $4,
  sale_price = $5
WHERE id = $1
RETURNING *;

-- name: DeletePriceAdjustment :exec
DELETE FROM price_adjustments
WHERE id = $1;