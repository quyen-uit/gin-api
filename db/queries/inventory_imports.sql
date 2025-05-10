-- ### INVENTORY_IMPORTS ###

-- name: GetInventoryImport :one
SELECT * FROM inventory_imports
WHERE id = $1 LIMIT 1;

-- name: ListInventoryImports :many
SELECT ii.*, v.name as vendor_name, ps.sku_code
FROM inventory_imports ii
JOIN vendors v ON ii.vendor_id = v.id
JOIN product_skus ps ON ii.sku_id = ps.id
ORDER BY ii.import_date DESC;

-- name: ListInventoryImportsBySkuID :many
SELECT ii.*, v.name as vendor_name
FROM inventory_imports ii
JOIN vendors v ON ii.vendor_id = v.id
WHERE sku_id = $1
ORDER BY import_date DESC;

-- name: ListInventoryImportsByVendorID :many
SELECT ii.*, ps.sku_code
FROM inventory_imports ii
JOIN product_skus ps ON ii.sku_id = ps.id
WHERE vendor_id = $1
ORDER BY import_date DESC;

-- name: CreateInventoryImport :one
INSERT INTO inventory_imports (
  sku_id,
  quantity,
  import_date,
  notes,
  vendor_id,
  price
) VALUES (
  $1, $2, $3, $4, $5, $6
)
RETURNING *;

-- name: DeleteInventoryImport :exec
DELETE FROM inventory_imports
WHERE id = $1;