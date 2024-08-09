use sakila;
-- --------------------------------------------------------------->>
# 1. All films with PG-13 Rating with rental rate of 2.99 0r lower
SELECT 
    *
FROM
    film
WHERE
    rating = 'PG-13' AND rental_rate <= 2.99;
-- ------------------------------------------------------>>   
# 2.All films that have deleted scenes
SELECT 
    title, special_features, release_year
FROM
    film
WHERE
    special_features LIKE '%Deleted Scenes%';
-- --------------------------------------------------->>
# 3. All Active Customers
SELECT 
    *
FROM
    customer
WHERE
    active = 1;
-- -------------------------------------------------->>
# How many active customers
SELECT 
    COUNT(active) AS Total_active_customers
FROM
    customer
WHERE
    active = 1;
-- -------------------------------------------------->>
# 4. Names of  customers who rented a movie on 26th  july 2005
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email,
    DATE(r.rental_date) AS rental_date,
    r.rental_id
FROM
    customer AS c
        JOIN
    rental AS r ON c.customer_id = r.customer_id
WHERE
    DATE(r.rental_date) = '2005-07-26';

-- ----------------------------------------------------->>
# 5.How many rentals we do in each day
SELECT 
    DATE(rental_date) AS Date, COUNT(*) AS Total_rentals
FROM
    rental
GROUP BY DATE(rental_date); 

SELECT 
    MAX(DATE(rental_date)) AS busiest_Date,
    COUNT(*) AS Total_rental
FROM
    rental;

-- ------------------------------------------------------->>

# 6.All scifi movie in our catalog
SELECT 
     c.name as category, f.title as Film_name,f.release_year
FROM
    film_category AS fc
        JOIN
    category AS c ON fc.category_id = c.category_id
        JOIN
    film AS f ON fc.film_id = f.film_id
WHERE
    c.name = 'Sci-Fi';

-- --------------------------------------------------------->>
# 7.customers and how many movie they rented so far order by max to min 
SELECT 
    r.customer_id AS id,
    CONCAT(c.first_name, ' ', c.last_name) AS Full_Name,
    COUNT(r.rental_id) AS Total_Rentals
FROM
    rental AS r
        JOIN
    customer AS c ON r.customer_id = c.customer_id
GROUP BY r.customer_id
order by Total_Rentals desc;
-- ------------------------------------------------------->>
# 8. Which movie should we discountinue from our catalogue (less than time lifetime rental)
WITH low AS
(SELECT 
    inventory_id, COUNT(*) AS Lifetime_rentals
FROM
    rental
GROUP BY inventory_id
HAVING COUNT(*) <= 1 )
SELECT 
    low.inventory_id, f.title AS Film_name, low.Lifetime_rentals
FROM
    low
        JOIN
    inventory AS i ON i.inventory_id = low.inventory_id
        JOIN
    film AS f ON i.film_id = f.film_id;
-- ------------------------------------------------------------------>>
# 9. WHICH MOVIES HAVEN'T BEEN RETURNED YET
WITH cte AS (
SELECT 
    inventory_id, customer_id, rental_date, return_date
FROM
    rental
WHERE
    return_date IS NULL)
SELECT 
    f.film_id, customer_id, f.title AS Film_name, rental_date
FROM
    cte
        JOIN
    inventory AS i ON cte.inventory_id = i.inventory_id
        JOIN
    film AS f ON i.film_id = f.film_id
ORDER BY f.title ;
-- ----------------------------------------------------------->>
# 10 .How much money and rental we make for store 1 by day
SELECT 
    s.store_id,
    SUM(p.amount) AS Total_amount,
    COUNT(p.rental_id) AS Total_rental,
    DAY(p.payment_date) AS `Business by Day`
FROM
    payment AS p
        JOIN
    store AS s ON p.staff_id = s.manager_staff_id
WHERE
    store_id = 1
GROUP BY s.store_id , DAY(p.payment_date);


# Top 3 earning day so far
SELECT 
    s.store_id,
    SUM(p.amount) AS Total_amount,
    COUNT(p.rental_id) AS Total_rental,
    DAY(p.payment_date) AS `Business by Day`
FROM
    payment AS p
        JOIN
    store AS s ON p.staff_id = s.manager_staff_id
WHERE
    store_id = 1
GROUP BY s.store_id , DAY(p.payment_date)
order by `Business by Day` desc
limit 3;


