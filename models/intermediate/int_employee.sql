SELECT
    j.EMPLOYEE_ID,
    j.NAME,
    j.CITY,
    j.ADDRESS,
    j.TITLE,
    j.ANNUAL_SALARY,
    j.HIRE_DATE_CLEANED,
    q.QUIT_DATE,
    CASE 
        WHEN q.QUIT_DATE IS NULL THEN 'Employed' 
        ELSE 'Quited' 
    END AS status,
    COALESCE(DATEDIFF('day', HIRE_DATE_CLEANED, QUIT_DATE), DATEDIFF('day', HIRE_DATE_CLEANED, CURRENT_DATE)) AS days_employed
FROM {{ ref('base_googledrive_hrjoins') }} j
LEFT JOIN {{ ref('base_googledrive_hrquits') }} q ON j.EMPLOYEE_ID = q.EMPLOYEE_ID
