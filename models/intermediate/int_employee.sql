SELECT
    j._FILE,
    j._LINE,
    j._MODIFIED_TS,
    j._FIVETRAN_SYNCED_TS,
    j.EMPLOYEE_ID,
    j.HIRE_DATE_CLEANED,
    j.NAME,
    j.CITY,
    j.ADDRESS,
    j.TITLE,
    j.ANNUAL_SALARY,
    q.QUIT_DATE
FROM {{ ref('base_googledrive_hrjoins') }} j
LEFT JOIN {{ ref('base_googledrive_hrquits') }} q ON j.EMPLOYEE_ID = q.EMPLOYEE_ID