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
SELECT p.prodid, p.descrip, SUM(i.qty) AS 'Quantity Sold'
FROM product p
   INNER JOIN item i ON p.prodid = i.prodid 
GROUP BY p.prodid, p.descrip;

--7
SELECT p.prodid, p.descrip, SUM(i.qty) AS 'Quantity Sold'
FROM product p
   INNER JOIN item i ON p.prodid = i.prodid 
   INNER JOIN ord o ON i.ordid = o.ordid
WHERE orderdate >= '2005-02-16'
GROUP BY p.prodid, p.descrip;


--8
SELECT c.name, COUNT(i.itemid) AS 'No of items ordered', printf("£%.2f",SUM(qty*actualprice)) AS 'Order Value'
FROM customer c
    INNER JOIN ord o ON c.custid = o.custid
    INNER JOIN item i ON o.ordid = i.ordid
WHERE orderdate >= '2005-02-02'
GROUP BY c.name;

--9
SELECT c.name, COUNT(i.itemid) AS 'No of items ordered', printf("£%.2f",SUM(qty*actualprice)) AS 'Order Value'
FROM customer c
    INNER JOIN ord o ON c.custid = o.custid
    INNER JOIN item i ON o.ordid = i.ordid
WHERE orderdate >= '2005-02-02'
GROUP BY c.name
HAVING COUNT(i.itemid) >= 5;

--10
SELECT e.ename, d.dname, COUNT(i.itemid) AS 'No of items ordered', printf("£%.2f",SUM(i.qty*i.actualprice)) AS 'Order Value'
FROM dept d
    INNER JOIN emp e ON d.deptno = e.deptno
    INNER JOIN customer c ON e.empno = c.repid
    INNER JOIN ord o ON c.custid = o.custid
    INNER JOIN item i ON o.ordid = i.ordid
WHERE orderdate >= '2005-02-02'
GROUP BY e.ename, d.dname
HAVING COUNT(o.ordid) >= 3
AND SUM(i.qty * i.actualprice) >= 1000;

--11
