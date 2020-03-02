--WEEK 5 NESTING QUERIES - PRACTCE
--SQLite

--1a
-- Useing the "DESC" command in "ORDER BY" to sort om hiredate in decending order.
SELECT ename, hiredate 
FROM emp 
ORDER BY hiredate DESC; 

--1b 
-- Using the LIMIT clause, display the employee who started most recently
SELECT ename, hiredate 
FROM emp 
ORDER BY hiredate DESC 
LIMIT 1; 

-- 1c
-- Using the LIMIT clause with an OFFSET, display the third longest-serving employee: 
-- setting the OFFSET to 0 would display the 1st row.
SELECT ename, hiredate 
FROM emp 
ORDER BY hiredate 
LIMIT 1 OFFSET 2; 

--1d
-- Using a sub-query with the LIMIT clause to display those employees who work in the same department as the longest-serving employee. Sort results by employee name. 
-- if the nested SELECT is not in () then a syntex error will occur
SELECT ename, deptno 
FROM emp 
WHERE deptno = 
    (SELECT deptno 
    FROM emp 
    ORDER BY hiredate 
    LIMIT 1); 

--2
-- Display the employee with the lowest salary using a nested query as follows: 
SELECT ename, monthly_sal, deptno
FROM emp
WHERE monthly_sal =
    (SELECT MIN(monthly_sal)
    FROM emp);
