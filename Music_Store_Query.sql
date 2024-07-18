--Q1: Who is the Senior most employee based on job title? 

SELECT * 
FROM employee
ORDER BY levels DESC
LIMIT 1;

--Q2: Which countries have the most Invoices?

SELECT COUNT(*), billing_country
FROM invoice
GROUP BY billing_country
ORDER BY COUNT(*) DESC;

--Q3: What are top 3 values of total Invoices?

SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3;

--Q4: Which city has the most profit?

SELECT billing_city, SUM(total) AS total_invoices
FROM invoice
GROUP BY billing_city
ORDER BY total_invoices DESC;

--Q5: Which customer has spent the most amounts of money?

SELECT c.customer_id, c.first_name, c.last_name, SUM(i.total) AS total
FROM customer AS c
INNER JOIN invoice AS i
ON c.customer_id = i.customer_id
GROUP BY c.customer_id
ORDER BY total DESC
LIMIT 1;

--Q6: Write query to return the email, first name, last name & Genre of all Rock Music listeners.
--Return your listed ordered alphabetically by email starting with A.

SELECT DISTINCT email, first_name, last_name
FROM customer AS c
INNER JOIN invoice AS i
ON c.customer_id = i.customer_id
INNER JOIN invoice_line as il
ON i.invoice_id = il.invoice_id
WHERE track_id IN (
	SELECT track_id
	FROM track AS t
	INNER JOIN genre AS g
	ON t.genre_id = g.genre_id
	WHERE g.name = 'Rock'
)
ORDER BY email ASC;

--Q7: Write a query that returns the Artist name and total track count of the top 10 rock bands.

SELECT a.name, COUNT(t.track_id) AS number_of_songs
FROM artist AS a
INNER JOIN album AS al
ON a.artist_id = al.artist_id
INNER JOIN track AS t
ON al.album_id = t.album_id
WHERE t.genre_id = '1'
GROUP BY a.name
ORDER BY number_of_songs DESC
LIMIT 10;

--Q8: Return all track names that have song length longer than the average song length.
-- Return name and milliseconds for each track.
-- Order by the song length with the longest name listed first.

SELECT name, milliseconds
FROM track
WHERE milliseconds > (
	SELECT AVG(milliseconds)
	FROM track
)
ORDER BY milliseconds DESC;

--Q9: Find how much amount spent by each customer on artists? 
-- Write a query to return customer name, artist name, and total spent.

WITH best_selling_artist AS (
	SELECT a.artist_id, a.name, SUM(il.unit_price * il.quantity) AS total_sales
	FROM artist AS a
	INNER JOIN album AS al
	ON a.artist_id = al.artist_id
	INNER JOIN track AS t
	ON al.album_id = t.album_id
	INNER JOIN invoice_line AS il
	ON t.track_id = il.track_id
	GROUP BY a.artist_id
	ORDER BY total_sales DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.name, 
	SUM(il.unit_price * il.quantity) AS total_sales
FROM customer AS c
INNER JOIN invoice AS i
ON c.customer_id = i.customer_id
INNER JOIN invoice_line AS il
ON i.invoice_id = il.invoice_id
INNER JOIN track AS t
ON il.track_id = t.track_id
INNER JOIN album AS a
ON t.album_id = a.album_id
INNER JOIN best_selling_artist AS bsa
ON a.artist_id = bsa.artist_id
GROUP BY 1,2,3,4
ORDER BY total_sales DESC;

--Q10: Write a Query to find out the most popular music Genre(highest quantity of purchases) for each country.

WITH popular_genre AS 
(
	SELECT COUNT(il.quantity) AS purchases, c.country, g.name, g.genre_id,
	ROW_NUMBER() OVER (PARTITION BY c.country ORDER BY COUNT(il.quantity) DESC) AS row_num
	FROM genre AS g
	INNER JOIN track AS t
	ON g.genre_id = t.genre_id
	INNER JOIN invoice_line as il
	ON t.track_id = il.track_id
	INNER JOIN invoice AS i
	ON il.invoice_id = i.invoice_id
	INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
	GROUP BY c.country, g.genre_id, g.name
	ORDER BY c.country ASC
)
SELECT *
FROM popular_genre
WHERE row_num <= 1;

--Q11: Write a query that determines the customer that has spent the most on music for each country.
-- Write a query that return the country along with the opt customer and how much they spent.
-- For countries where the top amount spend is shared provide all customers who spent this amount.

WITH RECURSIVE
customer_with_country AS (
    SELECT c.customer_id, c.first_name, c.last_name, i.billing_country, SUM(i.total) AS total_spending
    FROM customer AS c
    INNER JOIN invoice AS i
    ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, i.billing_country
),
country_max_spending AS (
    SELECT billing_country, MAX(total_spending) AS max_spending
    FROM customer_with_country
    GROUP BY billing_country
)
SELECT cwc.customer_id, cwc.first_name, cwc.last_name, cwc.billing_country, cwc.total_spending
FROM customer_with_country AS cwc
INNER JOIN country_max_spending AS cms
ON cwc.billing_country = cms.billing_country
WHERE cwc.total_spending = cms.max_spending
ORDER BY cwc.billing_country;



