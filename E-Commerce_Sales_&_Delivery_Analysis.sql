
-- ============================================================
-- E-COMMERCE SQL PROJECT
-- Database: EcommerceSQLProject
-- SQL Dialect: Google BigQuery
-- ============================================================


-- ============================================================
-- 1. BASIC EXPLORATORY ANALYSIS
-- ============================================================

-- Check the structure and sample records of customers

SELECT *
FROM `EcommerceSQLProject.customers`
LIMIT 10;


-- Check the geography/location table

SELECT *
FROM `EcommerceSQLProject.geoloaction`
LIMIT 5;


-- ============================================================
-- 2. TIME RANGE OF ORDERS
-- ============================================================

-- Get the time range between which the orders were placed

SELECT
    MIN(order_purchase_timestamp) AS start_time,
    MAX(order_purchase_timestamp) AS end_time
FROM `EcommerceSQLProject.orders`;


-- ============================================================
-- 3. CITIES & STATES OF CUSTOMERS
-- ============================================================

-- Display cities and states of customers who ordered
-- during January to March 2018

SELECT DISTINCT
    c.customer_city,
    c.customer_state
FROM `EcommerceSQLProject.orders` AS o
JOIN `EcommerceSQLProject.customers` AS c
    ON o.customer_id = c.customer_id
WHERE EXTRACT(YEAR FROM o.order_purchase_timestamp) = 2018
  AND EXTRACT(MONTH FROM o.order_purchase_timestamp) BETWEEN 1 AND 3
ORDER BY c.customer_state, c.customer_city;


-- ============================================================
-- 4. IN-DEPTH EXPLORATION
-- ============================================================

-- Is there a growing trend in the number of orders
-- placed over the years?
--
-- NOTE:
-- The previous query grouped only by MONTH.
-- That does NOT show yearly growth.
-- We should group by YEAR and MONTH.

SELECT
    EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
    EXTRACT(MONTH FROM order_purchase_timestamp) AS month,
    COUNT(order_id) AS order_num
FROM `EcommerceSQLProject.orders`
GROUP BY year, month
ORDER BY year, month;


-- ============================================================
-- 5. TIME OF DAY WHEN CUSTOMERS PLACE ORDERS
-- ============================================================

-- Dawn     : 00:00 - 06:59
-- Morning  : 07:00 - 12:59
-- Afternoon: 13:00 - 18:59
-- Night    : 19:00 - 23:59

SELECT
    CASE
        WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 0 AND 6
            THEN 'Dawn'
        WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 7 AND 12
            THEN 'Morning'
        WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 13 AND 18
            THEN 'Afternoon'
        WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 19 AND 23
            THEN 'Night'
    END AS day_time,
    COUNT(order_id) AS order_num
FROM `EcommerceSQLProject.orders`
GROUP BY day_time
ORDER BY order_num DESC;


-- ============================================================
-- 6. EVOLUTION OF E-COMMERCE ORDERS
-- ============================================================

-- Month-on-month number of orders placed

SELECT
    EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
    EXTRACT(MONTH FROM order_purchase_timestamp) AS month,
    COUNT(*) AS num_orders
FROM `EcommerceSQLProject.orders`
GROUP BY year, month
ORDER BY year, month;


-- ============================================================
-- 7. CUSTOMER DISTRIBUTION ACROSS STATES
-- ============================================================

SELECT
    customer_state,
    COUNT(DISTINCT customer_id) AS customer_count
FROM `EcommerceSQLProject.customers`
GROUP BY customer_state
ORDER BY customer_count DESC;


-- ============================================================
-- 8. IMPACT ON ECONOMY
-- ============================================================

-- Get the percentage increase in order payment value
-- from January-August 2017 to January-August 2018.


WITH yearly_totals AS (

    SELECT
        EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
        SUM(p.payment_value) AS total_payment
    FROM `EcommerceSQLProject.payments` AS p
    JOIN `EcommerceSQLProject.orders` AS o
        ON p.order_id = o.order_id
    WHERE EXTRACT(YEAR FROM o.order_purchase_timestamp) IN (2017, 2018)
      AND EXTRACT(MONTH FROM o.order_purchase_timestamp) BETWEEN 1 AND 8
    GROUP BY year

),

yearly_comparisons AS (

    SELECT
        year,
        total_payment,
        LAG(total_payment) OVER (
            ORDER BY year
        ) AS previous_year_payment
    FROM yearly_totals

)

SELECT
    year,
    total_payment,
    previous_year_payment,
    ROUND(
        SAFE_DIVIDE(
            total_payment - previous_year_payment,
            previous_year_payment
        ) * 100,
        2
    ) AS percentage_increase
FROM yearly_comparisons
WHERE year = 2018;


-- ============================================================
-- 9. TOTAL & AVERAGE ORDER PRICE AND FREIGHT BY STATE
-- ============================================================

SELECT
    c.customer_state,

    AVG(oi.price) AS avg_price,
    SUM(oi.price) AS total_price,

    AVG(oi.freight_value) AS avg_freight,
    SUM(oi.freight_value) AS total_freight

FROM `EcommerceSQLProject.order_items` AS oi

JOIN `EcommerceSQLProject.orders` AS o
    ON o.order_id = oi.order_id

JOIN `EcommerceSQLProject.customers` AS c
    ON o.customer_id = c.customer_id

GROUP BY c.customer_state
ORDER BY c.customer_state;


-- ============================================================
-- 10. DELIVERY TIME ANALYSIS
-- ============================================================

-- Calculate:
--
-- 1. Number of days taken to deliver the order
-- 2. Difference between actual and estimated delivery date
--
-- Interpretation of diff_estimated_delivery:
--
-- Negative = Delivered before estimated date
-- Zero     = Delivered on estimated date
-- Positive = Delivered after estimated date


SELECT
    order_id,

    DATE_DIFF(
        DATE(order_delivered_customer_date),
        DATE(order_purchase_timestamp),
        DAY
    ) AS days_to_delivery,

    DATE_DIFF(
        DATE(order_delivered_customer_date),
        DATE(order_estimated_delivery_date),
        DAY
    ) AS diff_estimated_delivery

FROM `EcommerceSQLProject.orders`
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;


-- ============================================================
-- 11. TOP 5 STATES WITH HIGHEST AVERAGE FREIGHT VALUE
-- ============================================================

SELECT
    c.customer_state,
    ROUND(AVG(oi.freight_value), 2) AS avg_freight_value

FROM `EcommerceSQLProject.order_items` AS oi

JOIN `EcommerceSQLProject.orders` AS o
    ON o.order_id = oi.order_id

JOIN `EcommerceSQLProject.customers` AS c
    ON o.customer_id = c.customer_id

GROUP BY c.customer_state
ORDER BY avg_freight_value DESC
LIMIT 5;


-- ============================================================
-- 12. TOP 5 STATES WITH LOWEST AVERAGE FREIGHT VALUE
-- ============================================================

SELECT
    c.customer_state,
    ROUND(AVG(oi.freight_value), 2) AS avg_freight_value

FROM `EcommerceSQLProject.order_items` AS oi

JOIN `EcommerceSQLProject.orders` AS o
    ON o.order_id = oi.order_id

JOIN `EcommerceSQLProject.customers` AS c
    ON o.customer_id = c.customer_id

GROUP BY c.customer_state
ORDER BY avg_freight_value ASC
LIMIT 5;


-- ============================================================
-- 13. TOP 5 STATES WITH HIGHEST AVERAGE DELIVERY TIME
-- ============================================================

SELECT
    c.customer_state,

    ROUND(
        AVG(
            DATE_DIFF(
                DATE(o.order_delivered_customer_date),
                DATE(o.order_purchase_timestamp),
                DAY
            )
        ),
        2
    ) AS avg_time_to_delivery

FROM `EcommerceSQLProject.orders` AS o

JOIN `EcommerceSQLProject.customers` AS c
    ON o.customer_id = c.customer_id

WHERE o.order_delivered_customer_date IS NOT NULL

GROUP BY c.customer_state
ORDER BY avg_time_to_delivery DESC
LIMIT 5;


-- ============================================================
-- 14. TOP 5 STATES WITH LOWEST AVERAGE DELIVERY TIME
-- ============================================================

SELECT
    c.customer_state,

    ROUND(
        AVG(
            DATE_DIFF(
                DATE(o.order_delivered_customer_date),
                DATE(o.order_purchase_timestamp),
                DAY
            )
        ),
        2
    ) AS avg_time_to_delivery

FROM `EcommerceSQLProject.orders` AS o

JOIN `EcommerceSQLProject.customers` AS c
    ON o.customer_id = c.customer_id

WHERE o.order_delivered_customer_date IS NOT NULL

GROUP BY c.customer_state
ORDER BY avg_time_to_delivery ASC
LIMIT 5;


-- ============================================================
-- 15. TOP 5 STATES WHERE DELIVERY WAS FAST
--     COMPARED TO THE ESTIMATED DATE
-- ============================================================

-- Logic:
--
-- actual delivery date - estimated delivery date
--
-- Negative value = delivered before estimated date.
--
-- Example:
-- -5 = delivered 5 days earlier than estimated
-- -2 = delivered 2 days earlier than estimated
--  0 = delivered exactly on estimated date
-- +3 = delivered 3 days later than estimated
--
-- Therefore, ORDER BY average difference ASC
-- gives the states with the fastest delivery
-- compared with their estimated delivery dates.


SELECT
    c.customer_state,

    ROUND(
        AVG(
            DATE_DIFF(
                DATE(o.order_delivered_customer_date),
                DATE(o.order_estimated_delivery_date),
                DAY
            )
        ),
        2
    ) AS avg_delivery_difference_days

FROM `EcommerceSQLProject.orders` AS o

JOIN `EcommerceSQLProject.customers` AS c
    ON o.customer_id = c.customer_id

WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL

GROUP BY c.customer_state
ORDER BY avg_delivery_difference_days ASC
LIMIT 5;


-- ============================================================
-- 16. PAYMENT ANALYSIS
-- ============================================================

-- Month-on-month number of orders placed
-- using different payment types

SELECT
    p.payment_type,

    EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,

    EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month,

    COUNT(DISTINCT o.order_id) AS order_count

FROM `EcommerceSQLProject.orders` AS o

JOIN `EcommerceSQLProject.payments` AS p
    ON o.order_id = p.order_id

GROUP BY
    p.payment_type,
    year,
    month

ORDER BY
    p.payment_type,
    year,
    month;


-- ============================================================
-- 17. NUMBER OF ORDERS BY PAYMENT INSTALLMENTS
-- ============================================================

SELECT
    payment_installments,
    COUNT(DISTINCT order_id) AS num_orders

FROM `EcommerceSQLProject.payments`

GROUP BY payment_installments

ORDER BY payment_installments;


-- ============================================================
-- END OF PROJECT
-- ============================================================

