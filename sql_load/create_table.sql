CREATE TABLE daily_sales(
    date DATE,
    year INTEGER,
    month INTEGER,
    dayOfWeek INTEGER,
    restaurant_name VARCHAR(50),
    cuision_type VARCHAR(15),
    category VARCHAR(30),
    city VARCHAR(10),
    orders INTEGER,
    sales INTEGER,
    net_sales NUMERIC(8,2),
    avg_order_value INTEGER,
    rating NUMERIC(2,1),
    customer_satisfaction NUMERIC(3,2),
    delivery_time_min INTEGER,
    delivery_time_actual INTEGER,
    is_weekend BOOLEAN,
    has_packaging_charges BOOLEAN,
    packaging_fee INTEGER,
    is_24x7 BOOLEAN,
    establishment_year INTEGER,
    commission_rate NUMERIC(3,2),
    is_festival BOOLEAN,
    is_promo BOOLEAN
);

alter table daily_sales
RENAME COLUMN cuision_type to cuisine_type;

ALTER TABLE daily_sales
alter COLUMN is_promo type INTEGER;