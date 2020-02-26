-- SQLite
-- WEEK 3 OTHER JOIN TYPES - EXERCISES (OUTER JOIN)

--1 
SELECT emp.job AS 'JOB', emp.ename, customer.name AS 'NAME'
FROM emp
    LEFT OUTER JOIN customer ON customer.repid = emp.empno
WHERE emp.deptno = 30 
ORDER BY emp.job, emp.ename, customer.name;

--2 
SELECT product.prodid, product.descrip, IFNULL (price.stdprice,'NOT YET SET') AS 'CURRENT PRICE'
FROM product
    LEFT OUTER JOIN price ON product.prodid = price.prodid
WHERE price.enddate IS NULL;

--3
SELECT customer.custid, customer.name, customer.area, ord.custid, item.itemid, item.qty
FROM customer
    LEFT OUTER JOIN ord ON customer.custid = ord.custid
    LEFT OUTER JOIN item ON ord.ordid = item.ordid
WHERE customer.area = 'HANT'
ORDER BY customer.name;

--4 
SELECT customer.custid, customer.name, customer.area, emp.ename AS 'SALES REP', ord.custid, item.itemid, item.qty
FROM customer
    LEFT OUTER JOIN ord ON customer.custid = ord.custid
    LEFT OUTER JOIN item ON ord.ordid = item.ordid
    LEFT OUTER JOIN emp ON customer.repid = emp.empno
WHERE customer.area = 'HANT'
ORDER BY customer.name;

--5
SELECT e.deptno, e.empno, e.ename AS 'Employee Name', e.mgr AS 'MANGER EMPNO', m.ename AS 'MANGER NAME'
FROM emp e
    INNER JOIN emp m ON e.mgr = m.empno
WHERE e.deptno = 10
OR e.deptno = 20
-- e.deptno IN (10, 20)
ORDER BY e.deptno, e.mgr;

--6 
SELECT e.ename AS 'Employee Name', d1.dname AS 'Employees Department', m.ename AS 'Manager Name', d2.dname AS 'Manager Department' 
FROM emp e  
    INNER JOIN emp m ON e.mgr = m.empno 
    INNER JOIN dept d1 ON e.deptno = d1.deptno  
    INNER JOIN dept d2 ON m.deptno = d2.deptno 
WHERE e.deptno <> m.deptno 
ORDER BY e.ename; 