WITH OrderTimes AS (
    SELECT SESSION_ID,
        MIN(ORDER_AT_TS) AS EarliestOrderTime,
        MAX(ORDER_AT_TS) AS LatestOrderTime
    FROM {{ref ('int_clean_orders')}}
    GROUP BY SESSION_ID
    HAVING COUNT(*) > 1 --@@Find all the problematic session_id@@
)

(SELECT i.SESSION_ID,
    i.PRICE_PER_UNIT,
    i.remove_from_cart_quantity,
    i.item_name,
    i.add_to_cart_quantity,
    i.ITEM_VIEW_AT_TS,
    CASE 
        WHEN i.ITEM_VIEW_AT_TS BETWEEN o.EarliestOrderTime AND o.LatestOrderTime THEN o.LatestOrderTime
        ELSE i.ITEM_VIEW_AT_TS 
    END AS AdjustedItemViewTS --@@Correct timestamp@@
FROM {{ref ('base_webschema_itemviews')}} AS i
INNER JOIN OrderTimes o ON i.SESSION_ID = o.SESSION_ID
WHERE i.SESSION_ID IN (SELECT SESSION_ID FROM OrderTimes))
    
UNION

(SELECT SESSION_ID, price_per_unit, remove_from_cart_quantity,item_name, add_to_cart_quantity, item_view_at_ts, item_view_at_ts AS AdjustedItemViewTS
FROM {{ref ('base_webschema_itemviews')}}
WHERE SESSION_ID NOT IN (SELECT SESSION_ID FROM OrderTimes))