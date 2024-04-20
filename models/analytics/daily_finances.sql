WITH orders as (
    SELECT 
        order_date,
        sum(clean_shipping_cost) daily_shipping_cost,
        SUM(total_price) as daily_order_amt
    FROM {{ ref('int_orders_withprice') }} 
    GROUP BY 1
    )

, refund as (
    SELECT 
        DATE(returned_at) as returned_date,
        SUM(CASE WHEN is_refunded = 'yes' THEN total_price ELSE 0 END) as daily_refund,
    FROM {{ ref('base_googledrive__returns') }}  r
    JOIN {{ ref('int_orders_withprice') }}  o 
    ON r.order_id = o.order_id
    GROUP BY 1
    )

, expense as (
    SELECT
        DATE,
        SUM(clean_expense_amount) AS daily_expense
    FROM {{ ref('base_googledrive__expense') }} 
    GROUP BY 1
    )

, hr_cost as (
    SELECT ROUND(SUM((annual_salary/365) * days_employed)/365, 0) as DAILY_AVG_SALARY
    FROM {{ ref('dim_employee') }} 
    )

SELECT
    o.order_date as _date,
    MAX(o.daily_order_amt) as daily_order_amt,
    MAX(o.daily_shipping_cost) as daily_shipping_cost,
    MAX(r.daily_refund) as daily_refund,
    MAX(e.daily_expense) as daily_expense,
    MAX(h.daily_avg_salary) as daily_avg_salary,
    MAX(o.daily_order_amt) - MAX(r.daily_refund) - MAX(e.daily_expense) - MAX(h.daily_avg_salary) as daily_profit
FROM orders o
FULL OUTER JOIN refund r ON o.order_date = r.returned_date
FULL OUTER JOIN expense e ON o.order_date = e.date
, hr_cost h
GROUP BY _date
ORDER BY _date ASC



