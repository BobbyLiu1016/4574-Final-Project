

WITH ranking AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY o.session_id ORDER BY o.ORDER_AT_TS DESC) AS row_n
    FROM {{ ref('base_webschema_orders')}} o
    JOIN {{ ref('int_clean_sessions')}} s
    ON o.session_id = s.session_id
)
SELECT CLIENT_ID, CLIENT_NAME, PHONE, SHIPPING_ADDRESS as ADDRESS, STATE, OS, IP
FROM ranking
WHERE row_n = 1





    

