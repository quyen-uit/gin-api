-- ### CUSTOMERS ###

-- name: GetCustomer :one
SELECT * FROM customers
WHERE id = $1 LIMIT 1;

-- name: GetCustomerByEmail :one
SELECT * FROM customers
WHERE email = $1 LIMIT 1;

-- name: ListCustomers :many
SELECT * FROM customers
ORDER BY last_name, first_name;

-- name: CreateCustomer :one
INSERT INTO customers (
  first_name,
  last_name,
  email,
  phone
) VALUES (
  $1, $2, $3, $4
)
RETURNING *;

-- name: UpdateCustomer :one
UPDATE customers
SET
  first_name = $2,
  last_name = $3,
  email = $4,
  phone = $5
WHERE id = $1
RETURNING *;

-- name: DeleteCustomer :exec
DELETE FROM customers
WHERE id = $1;