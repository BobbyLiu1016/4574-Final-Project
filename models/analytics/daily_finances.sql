WITH orders as (
    SELECT 
        order_date,
        ROUND(SUM(clean_shipping_cost),2) daily_shipping_cost,
        ROUND(SUM(total_price),2) as daily_order_amt
    FROM {{ ref('int_orders_withprice') }} 
    GROUP BY 1
    )

, refund as (
    SELECT 
        DATE(returned_at) as returned_date,
        ROUND(SUM(CASE WHEN is_refunded = 'yes' THEN total_price ELSE 0 END),2) as daily_refund,
    FROM {{ ref('base_googledrive__returns') }}  r
    JOIN {{ ref('int_orders_withprice') }}  o 
    ON r.order_id = o.order_id
    GROUP BY 1
    )

, expense as (
    SELECT
        DATE,
        ROUND(SUM(clean_expense_amount),2) AS daily_expense
    FROM {{ ref('base_googledrive__expense') }} 
    GROUP BY 1
    )

, hr_cost as (
    SELECT ROUND(SUM((annual_salary/365) * days_employed)/365, 2) as DAILY_AVG_SALARY
    FROM {{ ref('dim_employee') }} 
    )

SELECT
    e.date as _date,
    COALESCE(MAX(o.daily_order_amt),0) as daily_order_amt,
    COALESCE(MAX(o.daily_shipping_cost),0) as daily_shipping_cost,
    COALESCE(MAX(r.daily_refund),0) as daily_refund,
    COALESCE(MAX(e.daily_expense),0) as daily_expense,
    COALESCE(MAX(h.daily_avg_salary),0) as daily_avg_salary,
    ROUND(COALESCE(MAX(o.daily_order_amt),0) - COALESCE(MAX(r.daily_refund),0) - COALESCE(MAX(e.daily_expense),0) - COALESCE(MAX(h.daily_avg_salary),0),2) as daily_profit
FROM expense e
LEFT JOIN orders o ON o.order_date = e.date
LEFT JOIN refund r ON e.date = r.returned_date
, hr_cost h
GROUP BY e.date
ORDER BY e.date ASC



