SELECT
    o.CLIENT_NAME,
    o.ORDER_AT_TS,
    DATE(o.ORDER_AT_TS) AS ORDER_DATE,
    o.ORDER_ID,
    o.PAYMENT_INFO,
    o.PAYMENT_METHOD,
    o.PHONE,
    o.SESSION_ID,
    o.SHIPPING_ADDRESS,
    o.SHIPPING_COST,
    o.CLEAN_SHIPPING_COST,
    o.STATE,
    o.TAX_RATE,
    i.AGGREGATE_ITEM,
    i.TOTAL_PRICE
FROM 
    {{ ref('int_clean_orders') }} o
LEFT JOIN 
    {{ ref('int_item_aggre') }} i
ON 
    o.SESSION_ID = i.SESSION_ID AND DATE(o.ORDER_AT_TS) = i.ITEM_VIEW_AT_DATE