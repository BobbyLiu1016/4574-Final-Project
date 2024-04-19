SELECT
    EMPLOYEE_ID,
    NAME,
    CITY,
    ADDRESS,
    TITLE,
    ANNUAL_SALARY,
    HIRE_DATE_CLEANED,
    QUIT_DATE,
    CASE
        WHEN QUIT_DATE IS NULL THEN 'Employed'
        ELSE 'Quited'
    END AS status,
    COALESCE(DATEDIFF('day', HIRE_DATE_CLEANED, QUIT_DATE), DATEDIFF('day', HIRE_DATE_CLEANED, CURRENT_DATE)) AS days_employed
FROM {{ ref('int_employee') }}

