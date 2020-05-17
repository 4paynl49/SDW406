--Part 1 
--TASk A

SELECT  shopper_first_name AS first_name, 
        shopper_surname AS surname,  
        shopper_email_address AS email_address, 
        STRFTIME('%d/%m/%Y',date_joined) AS date_joined, 
        STRFTIME('%d/%m/%Y',date_of_birth) AS dob, cast((julianday(CURRENT_DATE)-julianday(date_of_birth))/365.25 as integer) as age_in_years
FROM shoppers   

WHERE date_joined >= '2020-01-01' 
AND date_of_birth > date('2020-01-01','-30 years')
ORDER BY  date_of_birth ASC, shopper_surname ASC

--Task B

SELECT  shopper_first_name AS first_name, 
        shopper_surname AS surname, 
        order_id AS order_number,
        STRFTIME('%d-%m-%Y',order_date) as order_date,
        quantity,
        printf("£%20.2f",price) as price,
        ordered_product_status as order_status, 
        product_description, 
        seller_name
FROM shoppers sh 
INNER JOIN shopper_orders so ON sh.shopper_id = so.shopper_id
INNER JOIN ordered_products op ON so.order_id = op.order_id
INNER JOIN products p ON op.product_id = p.product_id
INNER JOIN sellers se ON op.seller_id = se.seller_id 
WHERE sh.shopper_id = @Enter_shopper_ID
ORDER BY so.order_date DESC

--Task C
SELECT  seller_account_ref, 
        seller_name, 
        product_description,
        product_code,
        COUNT(op.quantity) AS number_of_orders,
        SUM(IFNULL(op.quantity, 0)) AS total_quantity_sold, 
        printf("£%20.2f",SUM(IFNULL(op.quantity, 0) * IFNULL(op.price, 0))) as total_value_of_all_sales
FROM product_sellers ps
    INNER JOIN sellers se on se.seller_id = ps.seller_id
    INNER JOIN products p ON p.product_id = ps.product_id
    LEFT OUTER JOIN
        (
            SELECT * FROM ordered_products op
            INNER JOIN shopper_orders so ON op.order_id = so.order_id 
                AND order_date >= '2019-06-01'
        )   op ON op.seller_id = ps.seller_id 
                AND op.product_id = ps.product_id
GROUP BY seller_account_ref, 
        seller_name, 
        product_description,
        product_code
ORDER BY
        seller_name, 
        product_description

/***
I firstly put the date in the join because there are three scenarios
1 - Sellers/Products without ANY orders
2 - Sellers/Products WITHOUT orders since 1st June 2019 BUT WITH orders BEFORE 1st June 2019
3 - Sellers/Products WITH orders since 1st June 2019

If the date logic was in the where clause rather than the join I would have returned nothing for scenario 2
but I wanted to make it so scenario 2 was the treated the same as scenario 3

However I then realised that I needed to do the lot as a nested query so that I could do a join from a left outer joined table
***/




