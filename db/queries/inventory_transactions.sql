-- ### INVENTORY_TRANSACTIONS ###

-- name: GetInventoryTransaction :one
SELECT * FROM inventory_transactions
WHERE id = $1 LIMIT 1;

-- name: ListInventoryTransactions :many
SELECT it.*, ps.sku_code
FROM inventory_transactions it
JOIN product_skus ps ON it.sku_id = ps.id
ORDER BY it.transaction_date DESC;

-- name: ListInventoryTransactionsBySkuID :many
SELECT * FROM inventory_transactions
WHERE sku_id = $1
ORDER BY transaction_date DESC;

-- name: ListInventoryTransactionsByReferenceIDAndType :many
SELECT * FROM inventory_transactions
WHERE reference_id = $1 AND transaction_type = $2
ORDER BY transaction_date DESC;

-- name: CreateInventoryTransaction :one
INSERT INTO inventory_transactions (
  sku_id,
  transaction_type,
  quantity,
  transaction_date,
  notes,
  reference_id,
  price
) VALUES (
  $1, $2, $3, $4, $5, $6, $7
)
RETURNING *;

-- name: DeleteInventoryTransaction :exec
DELETE FROM inventory_transactions
WHERE id = $1; -- Use with caution, transactions usually represent history