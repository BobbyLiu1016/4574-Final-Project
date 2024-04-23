SELECT
    DATE(SESSION_AT_TS) AS session_date,
    COUNT(*) AS total_sessions,
    SUM(HAS_ORDER) AS total_orders,
    ROUND((SUM(HAS_ORDER) * 100.0) / COUNT(*), 2) AS conversion_rate_percentage
FROM
    {{ ref('int_fact_session') }}
GROUP BY
    DATE(SESSION_AT_TS)
ORDER BY
    session_date