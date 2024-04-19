WITH item AS (
    SELECT 
        DISTINCT ITEM_NAME, 
        PRICE_PER_UNIT
    FROM {{ ref('base_webschema_itemviews') }}
    ORDER BY 1,2
    )

SELECT *, 
    CONCAT(ITEM_NAME, ' ($', PRICE_PER_UNIT, ')') as ITEM_PRICE, 
    ROW_NUMBER() OVER (ORDER BY ITEM_NAME, PRICE_PER_UNIT) AS ITEM_NO
FROM item
ORDER BY ITEM_NO
