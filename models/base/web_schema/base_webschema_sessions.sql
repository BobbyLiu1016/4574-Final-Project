SELECT 
    CLIENT_ID,
    IP,
    OS,
    SESSION_AT AS SESSION_AT_TS,
    SESSION_ID,
    _FIVETRAN_DELETED,
    _FIVETRAN_ID,
    _FIVETRAN_SYNCED AS _FIVETRAN_SYNCED_TS
FROM {{source('web_schema', 'sessions')}}