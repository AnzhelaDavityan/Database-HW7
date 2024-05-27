/*CTE Without the RECURSIVE keyword*/
WITH Numbers AS (
    SELECT generate_series(1, 100) AS n
)

SELECT
    n::VARCHAR,
    CASE
		WHEN n % 3 = 0 AND n % 5 = 0 THEN 'FizzBuzz'
		WHEN n % 3 = 0 THEN 'Fizz'
        WHEN n % 5 = 0 THEN 'Buzz'
        ELSE n::VARCHAR
    END AS FizzBuzz
FROM Numbers;


/*RECURSIVE CTE*/
WITH RECURSIVE Numbers AS (
    SELECT 1 AS n
    UNION
    SELECT n + 1
    FROM Numbers
    WHERE n < 100
)

SELECT
    n::VARCHAR,
    CASE
		WHEN n % 3 = 0 AND n % 5 = 0 THEN 'FizzBuzz'
        WHEN n % 3 = 0 THEN 'Fizz'
        WHEN n % 5 = 0 THEN 'Buzz'
        ELSE n::VARCHAR
    END AS FizzBuzz
FROM Numbers;
