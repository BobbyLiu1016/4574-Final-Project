SELECT
    ord.CLIENT_NAME,
    ses.CLIENT_ID_AS_STRING,
    ses.IP,
    ses.OS,
    ord.ORDER_AT_TS,
    ord.ORDER_DATE,
    ord.ORDER_ID,
    ord.SESSION_ID,
    ord.AGGREGATE_ITEM,
    ord.TOTAL_PRICE,
    ord.PAYMENT_INFO,
    ord.PAYMENT_METHOD,
    ord.PHONE,
    ord.SHIPPING_ADDRESS,
    ord.CLEAN_SHIPPING_COST,
    ord.STATE,
    ord.TAX_RATE,
FROM
    {{ ref('int_orders_withprice') }} ord
LEFT JOIN
    {{ ref('int_clean_sessions') }} ses
ON
    ord.SESSION_ID = ses.SESSION_ID