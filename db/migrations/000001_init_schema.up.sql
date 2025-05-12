-- Up Migration

-- Create enum types
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'order_status') THEN
        CREATE TYPE order_status AS ENUM ('pending', 'processing', 'shipping', 'completed', 'cancelled');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'return_order_status') THEN
        CREATE TYPE return_order_status AS ENUM ('pending', 'approved', 'rejected', 'completed');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'shipping_type') THEN
        CREATE TYPE shipping_type AS ENUM ('', 'standard', 'express');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'payment_type') THEN
        CREATE TYPE payment_type AS ENUM ('money', 'credit_card', 'bank_transfer');
    END IF;
END $$;

-- Tables without foreign keys
CREATE TABLE categories (
    id bigint primary key generated always as identity,
    name text not null,
    parent_id bigint,
    display_order integer default 0,
    is_active boolean default true
);

CREATE TABLE colors (
    id bigint primary key generated always as identity,
    name text not null,
    hex_code text
);

CREATE TABLE sizes (
    id bigint primary key generated always as identity,
    name text not null
);

CREATE TABLE product_brands (
    id bigint primary key generated always as identity,
    name text not null,
    country text not null,
    picture text,
    description text
);

CREATE TABLE products (
    id bigint primary key generated always as identity,
    name text not null,
    description text,
    category_id bigint,
    is_new boolean default false,
    is_trending boolean default false,
    is_active boolean default true,
    thumbnail text not null,
    brand_id bigint,
    properties json
);

CREATE TABLE users (
    id bigint primary key generated always as identity,
    username text unique not null,
    email text unique not null,
    password_hash text not null,
    created_at timestamp with time zone default now()
);

CREATE TABLE wishlists (
    id bigint primary key generated always as identity,
    created_at timestamp with time zone default now(),
    product_id bigint,
    user_id bigint
);

CREATE TABLE product_skus (
    id bigint primary key generated always as identity,
    product_id bigint,
    sku_code text unique not null,
    price numeric not null,
    is_active boolean default true,
    color_id bigint,
    size_id bigint
);

CREATE TABLE orders (
    id bigint primary key generated always as identity,
    user_id bigint,
    order_date timestamp with time zone default now(),
    total_amount numeric,
    status order_status not null,
    notes text,
    shipping_type shipping_type not null,
    payment_type payment_type not null,
    address text not null
);

CREATE TABLE order_items (
    id bigint primary key generated always as identity,
    order_id bigint,
    sku_id bigint,
    quantity integer not null,
    price numeric not null,
    amount numeric
);

CREATE TABLE price_adjustments (
    id bigint primary key generated always as identity,
    sku_id bigint,
    start_date timestamp with time zone not null,
    end_date timestamp with time zone not null,
    sale_price numeric not null
);

CREATE TABLE reviews (
    id bigint primary key generated always as identity,
    product_id bigint,
    user_id bigint,
    rating integer check (rating >= 1 AND rating <= 5),
    comment text not null,
    created_at timestamp with time zone default now()
);

CREATE TABLE sku_images (
    id bigint primary key generated always as identity,
    sku_id bigint,
    display_order integer default 0,
    image_url text not null
);

CREATE TABLE review_images (
    id bigint primary key generated always as identity,
    review_id bigint,
    image_url text not null
);

CREATE TABLE vendors (
    id bigint primary key generated always as identity,
    name text not null,
    phone text not null,
    address text,
    email text not null
);

CREATE TABLE inventory_imports (
    id bigint primary key generated always as identity,
    sku_id bigint,
    quantity integer not null,
    import_date timestamp with time zone default now(),
    notes text,
    vendor_id bigint,
    price numeric
);

CREATE TABLE inventory_adjustments (
    id bigint primary key generated always as identity,
    sku_id bigint,
    adjustment integer not null,
    adjustment_date timestamp with time zone default now(),
    reason text,
    created_date timestamp with time zone default now(),
    price numeric
);

CREATE TABLE inventory_transactions (
    id bigint primary key generated always as identity,
    sku_id bigint,
    transaction_type text check (transaction_type = ANY (ARRAY['import', 'adjustment'])),
    quantity integer not null,
    transaction_date timestamp with time zone default now(),
    notes text,
    reference_id bigint,
    price numeric
);

CREATE TABLE return_orders (
    id bigint primary key generated always as identity,
    order_id bigint,
    return_date timestamp with time zone default now(),
    reason text not null,
    status return_order_status not null,
    notes text,
    total_amount numeric,
    user_id bigint
);

CREATE TABLE return_order_items (
    id bigint primary key generated always as identity,
    return_order_id bigint,
    sku_id bigint,
    quantity integer not null,
    price numeric,
    amount numeric
);

CREATE TABLE carts (
    id bigint primary key generated always as identity,
    user_id bigint,
    created_at timestamp with time zone default now(),
    status text not null
);

CREATE TABLE cart_items (
    id bigint primary key generated always as identity,
    cart_id bigint,
    sku_id bigint,
    quantity integer not null,
    price numeric,
    amount numeric
);

-- Foreign key constraints
ALTER TABLE categories ADD CONSTRAINT fk_categories_parent FOREIGN KEY (parent_id) REFERENCES categories(id);
ALTER TABLE products ADD CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES categories(id);
ALTER TABLE products ADD CONSTRAINT fk_products_brand FOREIGN KEY (brand_id) REFERENCES product_brands(id);
ALTER TABLE wishlists ADD CONSTRAINT fk_wishlists_product FOREIGN KEY (product_id) REFERENCES products(id);
ALTER TABLE wishlists ADD CONSTRAINT fk_wishlists_user FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE product_skus ADD CONSTRAINT fk_skus_product FOREIGN KEY (product_id) REFERENCES products(id);
ALTER TABLE product_skus ADD CONSTRAINT fk_skus_color FOREIGN KEY (color_id) REFERENCES colors(id);
ALTER TABLE product_skus ADD CONSTRAINT fk_skus_size FOREIGN KEY (size_id) REFERENCES sizes(id);
ALTER TABLE orders ADD CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE order_items ADD CONSTRAINT fk_order_items_order FOREIGN KEY (order_id) REFERENCES orders(id);
ALTER TABLE order_items ADD CONSTRAINT fk_order_items_sku FOREIGN KEY (sku_id) REFERENCES product_skus(id);
ALTER TABLE price_adjustments ADD CONSTRAINT fk_price_adjustments_sku FOREIGN KEY (sku_id) REFERENCES product_skus(id);
ALTER TABLE reviews ADD CONSTRAINT fk_reviews_product FOREIGN KEY (product_id) REFERENCES products(id);
ALTER TABLE reviews ADD CONSTRAINT fk_reviews_user FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE sku_images ADD CONSTRAINT fk_sku_images_sku FOREIGN KEY (sku_id) REFERENCES product_skus(id);
ALTER TABLE review_images ADD CONSTRAINT fk_review_images_review FOREIGN KEY (review_id) REFERENCES reviews(id);
ALTER TABLE inventory_imports ADD CONSTRAINT fk_inventory_imports_sku FOREIGN KEY (sku_id) REFERENCES product_skus(id);
ALTER TABLE inventory_imports ADD CONSTRAINT fk_inventory_imports_vendor FOREIGN KEY (vendor_id) REFERENCES vendors(id);
ALTER TABLE inventory_adjustments ADD CONSTRAINT fk_inventory_adjustments_sku FOREIGN KEY (sku_id) REFERENCES product_skus(id);
ALTER TABLE inventory_transactions ADD CONSTRAINT fk_inventory_transactions_sku FOREIGN KEY (sku_id) REFERENCES product_skus(id);
ALTER TABLE return_orders ADD CONSTRAINT fk_return_orders_order FOREIGN KEY (order_id) REFERENCES orders(id);
ALTER TABLE return_orders ADD CONSTRAINT fk_return_orders_user FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE return_order_items ADD CONSTRAINT fk_return_order_items_return_order FOREIGN KEY (return_order_id) REFERENCES return_orders(id);
ALTER TABLE return_order_items ADD CONSTRAINT fk_return_order_items_sku FOREIGN KEY (sku_id) REFERENCES product_skus(id);
ALTER TABLE carts ADD CONSTRAINT fk_carts_user FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE cart_items ADD CONSTRAINT fk_cart_items_cart FOREIGN KEY (cart_id) REFERENCES carts(id);
ALTER TABLE cart_items ADD CONSTRAINT fk_cart_items_sku FOREIGN KEY (sku_id) REFERENCES product_skus(id);