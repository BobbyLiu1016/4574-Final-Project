WITH view_0_item_session_cte AS (
    SELECT S.SESSION_ID
    FROM {{ref ('int_fact_session')}} AS S
    LEFT JOIN {{ref ('int_clean_itemviews')}} AS IV
    ON S.SESSION_ID = IV.SESSION_ID
    WHERE IV.SESSION_ID IS NULL -- Find SESSION that view 0 item
), summary_table AS(
SELECT SESSION_ID,
        CASE WHEN VISITED_SHOP_PLANTS > 0 THEN 1 ELSE 0 END AS VIEW_SHOPPING_PAGE,
        CASE WHEN (VISITED_SHOP_PLANTS > 0 AND SESSION_ID NOT IN (SELECT SESSION_ID FROM view_0_item_session_cte)) THEN 1 ELSE 0 END AS VIEW_AT_LEAST_ONE_ITEM,
        CASE WHEN (VISITED_CART > 0 AND NET_QUANTITY_ADDED > 0) THEN 1 ELSE 0 END AS ADD_AT_LEAST_1_TO_CART,
        HAS_ORDER
FROM {{ref ('int_fact_session')}}
)
SELECT SUM(VIEW_SHOPPING_PAGE) AS VIEW_SHOPPING_PAGE,
    SUM(VIEW_AT_LEAST_ONE_ITEM) AS VIEW_AT_LEAST_ONE_ITEM,
    SUM(ADD_AT_LEAST_1_TO_CART) AS ADD_AT_LEAST_1_TO_CART,
    SUM(HAS_ORDER) AS HAS_ORDER
FROM summary_table