-- SQLite
--WEEK 2 RETRIEVING DATA FROM MULTIPLE TABLES (JOINS) ANSWERS TO EXERCISES  

--1
SELECT customer.name, customer.creditlimit, ord.ordid, ord.orderdate
FROM customer
    INNER JOIN ord ON customer.custid = ord.custid
WHERE ord.orderdate > '2005-01-01'
ORDER BY customer.name , ord.orderdate;
--2
SELECT  emp.ename AS 'Rep', customer.name, customer.area, customer.creditlimit
FROM emp
    INNER JOIN customer ON emp.empno = customer.repid  
ORDER BY emp.ename, customer.name;

--3a
SELECT product.prodid, descrip AS 'DESCRIPTION', startdate, stdprice AS 'CURRENT PRICE', enddate
FROM product
    INNER JOIN price ON product.prodid = price.prodid
WHERE enddate is NULL
ORDER BY product.prodid;

--3b  printf("£%.2f", <floatField>) AS '<Name.me>' 
--    FROM 'NameMe' 
-- use the syntax above to add '£' and 2 decimal places prefixed
SELECT product.prodid, descrip AS 'DESCRIPTION', startdate, printf("£%.2f",stdprice) AS 'CURRENT PRICE', enddate
FROM product
    INNER JOIN price ON product.prodid = price.prodid
WHERE enddate is NULL
ORDER BY product.prodid;

--4
SELECT item.ordid, item.itemid, item.prodid, product.descrip
FROM item
    INNER JOIN product ON product.prodid = item.prodid
WHERE item.ordid = 612
ORDER BY item.itemid;

--5
SELECT emp.ename AS 'Rep', customer.name, ord.ordid, ord.orderdate
FROM emp  INNER JOIN  customer ON emp.empno = customer.repid  
    INNER JOIN ord ON customer.custid = ord.custid
WHERE ord.orderdate >= '2005-01-01'
AND emp.ename = 'ALLEN';

--6
SELECT emp.ename AS 'Rep', customer.name, ord.ordid, ord.orderdate, item.itemid, product.prodid, product.descrip
FROM emp INNER JOIN customer ON emp.empno = customer.repid  
    INNER JOIN ord ON customer.custid = ord.custid
    INNER JOIN item ON ord.ordid = item.ordid
    INNER JOIN product ON item.prodid = product.prodid
WHERE item.ordid = 612
ORDER BY item.itemid;

--7
SELECT item.ordid, item.itemid, item.qty AS 'QTY ORDERED', delivered_item.delid, delivered_item.qty AS 'QTY DELIVERED'
FROM item
    INNER JOIN delivered_item ON item.ordid = delivered_item.ordid
    AND item.itemid = delivered_item.itemid
WHERE item.ordid = 612;