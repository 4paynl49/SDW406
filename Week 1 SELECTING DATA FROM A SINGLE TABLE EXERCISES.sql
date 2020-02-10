--SQLite
--Week 1 SELECTING DATA FROM A SINGLE TABLE EXERCISES

--1 
SELECT *
FROM emp;

--2 
SELECT *
FROM emp
ORDER BY ename;

--3
SELECT *
FROM emp
WHERE job = 'SALESMAN';

--4 
SELECT *
FROM emp
WHERE monthly_sal > '2500';

--5 
SELECT ename, job, hiredate, deptno
FROM emp
WHERE hiredate >= '1982-01-01';

--6
SELECT ename, job, commission, deptno
FROM emp
WHERE commission IS NOT NULL;

--7
SELECT ename, job, mgr, hiredate, commission 
FROM emp
WHERE mgr IS NULL
OR mgr = '7782';

--8
SELECT ename, job, mgr, hiredate, commission 
FROM emp
WHERE mgr = '7566' OR commission IS NOT NULL
AND hiredate >= '1981-09-08';

--9
SELECT ename, monthly_sal*12, commission
FROM emp
WHERE deptno = '30';

--10
SELECT ename,  monthly_sal*12+ IFNULL(commission,0) AS 'ANNUAL EARNINGS'
FROM emp
WHERE deptno = '30';

--11
SELECT empno||' '||ename AS 'EMPLOYEE', monthly_sal*1.2 AS 'MONTHLY SALARY + 20%'
FROM emp
WHERE deptno = '30';

--12
SELECT empno||' '||ename AS 'EMPLOYEE', monthly_sal*1.2 AS 'MONTHLY SALARY + 20%'
FROM emp
WHERE ename LIKE 'A%' 
OR ename LIKE 'S%' 
ORDER BY 'EMPLOYEE';

--13
SELECT name, area
FROM customer
WHERE area = @AREA1
OR area = @AREA2;

--14
SELECT prodid, stdprice as 'PRICE', STRFTIME('%d/%m/%Y',startdate) AS 'STARTDATE', STRFTIME('%d/%m/%Y',enddate) AS 'ENDDATE',JULIANDAY (enddate) - JULIANDAY (startdate) AS 'DURATION IN DAYS'
FROM price
WHERE enddate IS NOT NULL;
