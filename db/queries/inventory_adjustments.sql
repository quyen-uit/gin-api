-- ### INVENTORY_ADJUSTMENTS ###

-- name: GetInventoryAdjustment :one
SELECT * FROM inventory_adjustments
WHERE id = $1 LIMIT 1;

-- name: ListInventoryAdjustments :many
SELECT ia.*, ps.sku_code
FROM inventory_adjustments ia
JOIN product_skus ps ON ia.sku_id = ps.id
ORDER BY ia.adjustment_date DESC;

-- name: ListInventoryAdjustmentsBySkuID :many
SELECT * FROM inventory_adjustments
WHERE sku_id = $1
ORDER BY adjustment_date DESC;

-- name: CreateInventoryAdjustment :one
INSERT INTO inventory_adjustments (
  sku_id,
  adjustment,
  adjustment_date,
  reason,
  created_date,
  price
) VALUES (
  $1, $2, $3, $4, $5, $6
)
RETURNING *;

-- name: DeleteInventoryAdjustment :exec
DELETE FROM inventory_adjustments
WHERE id = $1;