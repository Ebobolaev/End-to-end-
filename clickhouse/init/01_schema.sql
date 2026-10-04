-- =========================================================
-- Stream Analytics - схема ClickHouse
-- Интернет-магазин: справочник пользователей + поток заказов
-- =========================================================

CREATE DATABASE IF NOT EXISTS analytics;

-- Справочник пользователей
CREATE TABLE IF NOT EXISTS analytics.users
(
    user_id      UInt32,
    name         String,
    city         LowCardinality(String),
    segment      LowCardinality(String),
    signup_date  Date
)
ENGINE = MergeTree
ORDER BY (user_id);

-- Поток заказов (события)
CREATE TABLE IF NOT EXISTS analytics.orders
(
    order_id     UInt64,
    user_id      UInt32,
    event_time   DateTime,
    product      LowCardinality(String),
    category     LowCardinality(String),
    price        Float32,
    quantity     UInt8,
    amount       Float32,
    city         LowCardinality(String),
    is_anomaly   UInt8 DEFAULT 0
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(event_time)
ORDER BY (event_time, user_id);

-- Materialized View: агрегаты по минутам, категориям и городам
CREATE MATERIALIZED VIEW IF NOT EXISTS analytics.orders_by_minute
ENGINE = SummingMergeTree
PARTITION BY toYYYYMM(minute)
ORDER BY (minute, category, city)
AS
SELECT
    toStartOfMinute(event_time) AS minute,
    category,
    city,
    count()                     AS orders_count,
    sum(amount)                 AS revenue,
    sum(quantity)               AS total_quantity,
    sum(is_anomaly)             AS anomaly_count
FROM analytics.orders
GROUP BY minute, category, city;

