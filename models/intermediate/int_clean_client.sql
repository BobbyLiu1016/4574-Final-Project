

SELECT CLIENT_ID, CLIENT_NAME, PHONE, SHIPPING_ADDRESS as ADDRESS, STATE, OS, IP
FROM {{ ref('base_webschema_orders')}}
JOIN {{ ref('base_webschema_sessions')}}
ON {{ ref('base_webschema_orders')}}.SESSION_ID = {{ ref('base_webschema_sessions')}}.SESSION_ID

    

