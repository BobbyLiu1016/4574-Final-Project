WITH session_join_pageviews AS(
    SELECT s.SESSION_ID, 
            s.CLIENT_ID, 
            s.CLIENT_ID_AS_STRING, 
            PAGE_NAME
    FROM {{ref ('int_clean_sessions') }} AS s
    LEFT JOIN {{ref ('base_webschema_pageviews') }} AS pv ON s.session_id = pv.session_id
    ORDER BY s.session_id, client_id
),
session_page_visits AS (
  SELECT
    SESSION_ID,client_id,
    SUM(CASE WHEN PAGE_NAME = 'faq' THEN 1 ELSE 0 END) AS visited_faq,
    SUM(CASE WHEN PAGE_NAME = 'cart' THEN 1 ELSE 0 END) AS visited_cart,
    SUM(CASE WHEN PAGE_NAME = 'landing_page' THEN 1 ELSE 0 END) AS visited_landing_page,
    SUM(CASE WHEN PAGE_NAME = 'plant_care' THEN 1 ELSE 0 END) AS visited_plant_care,
    SUM(CASE WHEN PAGE_NAME = 'shop_plants' THEN 1 ELSE 0 END) AS visited_shop_plants
  FROM session_join_pageviews
  GROUP BY SESSION_ID, client_id --@@@Calculate the number of visits to various pages during a single session.@@@
),
quantity_cte AS (
    SELECT SESSION_ID, 
        SUM(ADD_TO_CART_QUANTITY) AS TOTAL_QUANTITY_ADDED, 
        SUM(REMOVE_FROM_CART_QUANTITY) AS TOTAL_QUANTITY_REMOVED, 
        (SUM(ADD_TO_CART_QUANTITY) - SUM(REMOVE_FROM_CART_QUANTITY)) AS NET_QUANTITY_ADDED
    FROM {{ref ('int_clean_itemviews') }}
    GROUP BY SESSION_ID --@@@Calculate the changes in quantity during a single session.@@@
),
order_cte AS (
    SELECT S.SESSION_ID, 
        ORDER_ID, 
        CASE WHEN ORDER_ID IS NOT NULL THEN 1 ELSE 0 END AS order_indicator
    FROM {{ref ('int_clean_sessions') }} AS S
    LEFT JOIN {{ref ('base_webschema_orders') }} AS O ON S.SESSION_ID = O.SESSION_ID
    ORDER BY S.SESSION_ID
),
has_order_cte AS (
    SELECT SESSION_ID, 
        CASE WHEN SUM(ORDER_INDICATOR) >= 1 THEN 1 ELSE 0 END AS has_order
    FROM order_cte
    GROUP BY SESSION_ID --@@@Calculate if there is an order during a single session.@@@
)
SELECT S.SESSION_ID, 
    CLIENT_ID_AS_STRING AS CREATED_BY_CLIENT,
    SESSION_AT_TS,
    IP, 
    OS,
    session_page_visits.CLIENT_ID,
    visited_faq,
    visited_cart,
    visited_landing_page,
    visited_plant_care,
    visited_shop_plants,
    COALESCE(TOTAL_QUANTITY_ADDED, 0) AS TOTAL_QUANTITY_ADDED,
    COALESCE(TOTAL_QUANTITY_REMOVED, 0) AS TOTAL_QUANTITY_REMOVED,
    COALESCE(NET_QUANTITY_ADDED, 0) AS NET_QUANTITY_ADDED,
    has_order
    
FROM {{ref ('int_clean_sessions') }} AS S
LEFT JOIN session_page_visits ON S.SESSION_ID = session_page_visits.SESSION_ID
LEFT JOIN quantity_cte ON S.SESSION_ID = quantity_cte.SESSION_ID
LEFT JOIN has_order_cte ON S.SESSION_ID = has_order_cte.SESSION_ID