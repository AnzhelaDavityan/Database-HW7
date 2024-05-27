/*Recursive*/
EXPLAIN ANALYZE
WITH RECURSIVE string_generator AS (
    SELECT 'a' AS str
    UNION ALL
    SELECT str || 'a'
    FROM string_generator
    WHERE LENGTH(str) < 1000
)
SELECT str FROM string_generator;

/*Non-Recursive*/
EXPLAIN ANALYZE
WITH non_recursive_string_generator AS (
    SELECT REPEAT('a', 1000) AS str
)
SELECT str FROM non_recursive_string_generator;

/*
Recursive CTE:
Planning Time: 0.101 ms
Execution Time: 2.999 ms

Non-Recursive CTE:
Planning Time: 0.066 ms
Execution Time: 0.015 ms

Recursive CTE has a higher planning time (0.101 ms),that is higher than the 
non-recursive CTE (0.066 ms).The increased planning time for the recursive CTE can be 
attributed to the complexity of determining how to execute the recursive part of the query. 
The query planner must account for the recursive self-reference and decide on the strategy 
for accumulating results and the point of termination.Planner requires much more time as 
recursive CTEs include multiple iterations, and the planner also needs to determine the 
most efficient way of conducting the recursive steps and identifying the termination conditions.

The execution time for the recursive CTE is significantly higher than the non-recursive CTE. 
In fact, it's almost 200 times longer. The recursive CTE builds the string in an iterative manner.
This is a step-by-step process, where each step involves adding one  character to the existing 
string.For a string of length 1000, this means 1000 iterations. As the string gets longer, 
the time it takes to perform each concatenation increases. Also, at each iteration, 
the recursive CTE must check whether the termination condition (LENGTH(str) < 1000) is met.
This length check is an overhead that occurs at every iteration, adding to the cumulative 
execution time. As the string grows with each concatenation, more memory needs to be 
allocated to accommodate the increasing size,which adds to the execution time. On the 
other hand,the non-recursive CTE simply uses a REPEAT function to create the string in 
one operation. As a result, the non-recursive CTE has a significantly lower execution time
because it does all the work in one step.

The recursive CTE has worse performance both in planning and execution due to the overhead 
of managing recursion. The non-recursive CTE benefits from the database's optimized handling 
of straightforward operations, resulting in lower planning and execution times.
When an operation can be executed without recursion, it's generally more efficient to do so. 




*/