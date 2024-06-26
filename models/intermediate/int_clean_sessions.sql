WITH session_cte AS (
    SELECT *,
        ROW_NUMBER() OVER(PARTITION BY SESSION_ID ORDER BY SESSION_AT_TS) AS SESSION_AT_RANK
    FROM {{ ref('base_webschema_sessions')}}
)
SELECT CLIENT_ID,
    CLIENT_ID_AS_STRING,
    IP,
    OS,
    SESSION_AT_TS,
    SESSION_ID,
    _FIVETRAN_DELETED,
    _FIVETRAN_ID,
    _FIVETRAN_SYNCED_TS
FROM session_cte
WHERE SESSION_AT_RANK = 1
