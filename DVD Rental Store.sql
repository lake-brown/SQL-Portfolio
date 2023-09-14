--In this SQL I performed extensive queries on a multi-table database to conduct data analysis about customer and rental data.

--1.create a list of all distinct districts?

SELECT DISTINCT district 
FROM address;

--2. how many films does the company have?

SELECT COUNT(film_id)
FROM inventory;

--3.what is the latest rental dates?

SELECT MAX(rental_date) AS
latest_rentals
FROM rental;


--4. How many payments are there where the amount is either 0 or is between 3.99 and 7.99 and in the same time has happened on 2020-05-01?

SELECT COUNT(*) FROM payment
WHERE amount = 0 OR 
(amount >= 3.99 AND amount <= 7.99);




--5. What film was rented the most?

SELECT rental_id, COUNT(rental_id) AS rental_count 
FROM payment
GROUP BY rental_id
ORDER BY rental_count DESC
LIMIT 1;


--6. What is the title of the film that was rented the most?

SELECT film.title, payment.rental_id, COUNT(payment.rental_id) AS rental_count FROM payment
INNER JOIN rental
ON payment.rental_id = rental.rental_id
INNER JOIN inventory
ON rental.inventory_id = inventory.inventory_id
INNER JOIN  film
ON inventory.film_id = film.film_id
GROUP BY film.title, payment.rental_id
ORDER BY rental_count DESC
LIMIT 1;



 
--7. what is the average payment amount grouped by customer and day - consider the only days/customeres with more than 1 payment (per customer per day). order by average amount in a descending order

SELECT customer_id, date(payment_date), ROUND(AVG(amount),2) AS avg_amount, COUNT(*) FROM payment
WHERE DATE(payment_date) IN ('2007-04-08', '2007-04-29', '2007-04-30')
GROUP BY customer_id, date(payment_date)
HAVING COUNT(*) > 1
ORDER BY 3  DESC 

--In 2007, april 8,29,and 30 where days of very high revenue. which is why i focused on these days.


--This analysis encompassed an examination of distinct districts, specific payment transactions, identification of the most frequently rented movie, determination of the movies title, and the calculation of payment amounts catagorized by both custome and day.


