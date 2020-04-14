--Part 1 
--TASk A

SELECT  shopper_first_name AS 'FIRST NAME', 
        shopper_surname AS 'SURNAME',  
        shopper_email_address AS 'EMAIL ADDRESS', 
        STRFTIME('%d/%m/%Y',date_joined) AS 'DATE JOINTED', 
        STRFTIME('%d/%m/%Y',date_of_birth) AS 'DOB', cast((julianday(CURRENT_DATE)-julianday(date_of_birth))/365.25 as integer) as 'AGE IN YEARS'
FROM shoppers      
WHERE date_joined >= '2020-01-01' 
OR date_of_birth BETWEEN 1 AND 29 
ORDER BY  date_of_birth ASC, shopper_surname ASC





