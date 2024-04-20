SELECT 
    SESSION_ID,
    ITEM_VIEW_AT_DATE,
    LISTAGG(ITEM_NAME, ', ') WITHIN GROUP (ORDER BY ITEM_NAME) AS AGGREGATE_ITEM, 
    SUM(NET_QUANTITY * PRICE_PER_UNIT) AS TOTAL_PRICE 
FROM 
    {{ ref('int_itemview_price') }}
GROUP BY 
    SESSION_ID,
    ITEM_VIEW_AT_DATE