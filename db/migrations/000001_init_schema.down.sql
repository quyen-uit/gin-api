
-- Down Migration

-- Drop foreign key constraints
ALTER TABLE categories DROP CONSTRAINT IF EXISTS fk_categories_parent;
ALTER TABLE products DROP CONSTRAINT IF EXISTS fk_products_category;
ALTER TABLE products DROP CONSTRAINT IF EXISTS fk_products_brand;
ALTER TABLE wishlists DROP CONSTRAINT IF EXISTS fk_wishlists_product;
ALTER TABLE wishlists DROP CONSTRAINT IF EXISTS fk_wishlists_user;
ALTER TABLE product_skus DROP CONSTRAINT IF EXISTS fk_skus_product;
ALTER TABLE product_skus DROP CONSTRAINT IF EXISTS fk_skus_color;
ALTER TABLE product_skus DROP CONSTRAINT IF EXISTS fk_skus_size;
ALTER TABLE orders DROP CONSTRAINT IF EXISTS fk_orders_customer;
ALTER TABLE order_items DROP CONSTRAINT IF EXISTS fk_order_items_order;
ALTER TABLE order_items DROP CONSTRAINT IF EXISTS fk_order_items_sku;
ALTER TABLE price_adjustments DROP CONSTRAINT IF EXISTS fk_price_adjustments_sku;
ALTER TABLE reviews DROP CONSTRAINT IF EXISTS fk_reviews_product;
ALTER TABLE reviews DROP CONSTRAINT IF EXISTS fk_reviews_customer;
ALTER TABLE sku_images DROP CONSTRAINT IF EXISTS fk_sku_images_sku;
ALTER TABLE review_images DROP CONSTRAINT IF EXISTS fk_review_images_review;
ALTER TABLE inventory_imports DROP CONSTRAINT IF EXISTS fk_inventory_imports_sku;
ALTER TABLE inventory_imports DROP CONSTRAINT IF EXISTS fk_inventory_imports_vendor;
ALTER TABLE inventory_adjustments DROP CONSTRAINT IF EXISTS fk_inventory_adjustments_sku;
ALTER TABLE inventory_transactions DROP CONSTRAINT IF EXISTS fk_inventory_transactions_sku;
ALTER TABLE return_orders DROP CONSTRAINT IF EXISTS fk_return_orders_order;
ALTER TABLE return_order_items DROP CONSTRAINT IF EXISTS fk_return_order_items_return_order;
ALTER TABLE return_order_items DROP CONSTRAINT IF EXISTS fk_return_order_items_sku;
ALTER TABLE carts DROP CONSTRAINT IF EXISTS fk_carts_customer;
ALTER TABLE cart_items DROP CONSTRAINT IF EXISTS fk_cart_items_cart;
ALTER TABLE cart_items DROP CONSTRAINT IF EXISTS fk_cart_items_sku;

-- Drop tables
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS carts;
DROP TABLE IF EXISTS return_order_items;
DROP TABLE IF EXISTS return_orders;
DROP TABLE IF EXISTS inventory_transactions;
DROP TABLE IF EXISTS inventory_adjustments;
DROP TABLE IF EXISTS inventory_imports;
DROP TABLE IF EXISTS vendors;
DROP TABLE IF EXISTS review_images;
DROP TABLE IF EXISTS sku_images;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS price_adjustments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS product_skus;
DROP TABLE IF EXISTS wishlists;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS product_brands;
DROP TABLE IF EXISTS sizes;
DROP TABLE IF EXISTS colors;
DROP TABLE IF EXISTS categories;

-- Drop enum types
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'order_status') THEN
        DROP TYPE order_status;
    END IF;
    IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'return_order_status') THEN
        DROP TYPE return_order_status;
    END IF;
    IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'shipping_type') THEN
        DROP TYPE shipping_type;
    END IF;
    IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'payment_type') THEN
        DROP TYPE payment_type;
    END IF;
END $$;