-- SQLite
--WEEK 4 SUMMARISING DATA  EXERCISES 

--1 
SELECT  MIN(monthly_sal) AS 'Minimum Salary', 
        MAX(monthly_sal) AS 'Maximum Salary',
        AVG(monthly_sal) AS 'Average Salary',
        COUNT(empno) AS 'No of Employees'
FROM emp;

--2
SELECT prodid, SUM(qty) AS 'Quantity sold'
FROM item
WHERE prodid = '100870';

--3
SELECT prodid, SUM(qty) AS 'Quantity sold'
FROM item
GROUP BY prodid;

--4
SELECT ordid, printf("£%.2f",SUM(qty*actualprice)) AS 'Order Value'
FROM item
WHERE ordid <= '605'
GROUP BY ordid;

--5
SELECT  ordid, printf("£%.2f",SUM(qty*actualprice)) AS 'Order Value',
        COUNT(*) AS 'No of items',
        AVG(qty) AS 'Average Qty'
FROM item
WHERE ordid <= '605'
GROUP BY ordid;

--6

--7

--8

--9

--10

--11
