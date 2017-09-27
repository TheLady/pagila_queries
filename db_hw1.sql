

-- 1a. You need a list of all the actors’ first name and last name

SELECT first_name, last_name 
FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. 
-- Name the column Actor Name

SELECT concat(first_name, ' ', last_name) AS Actor_Name
FROM actor;

-- 2a. You need to find the id, first name, and last name of an actor, 
-- of whom you know only the first name of "Joe." 
-- What is one query would you use to obtain this information?

SELECT actor_id, first_name, last_name
FROM actor
WHERE upper(first_name) = upper('joe');

-- 2b. Find all actors whose last name contain the letters GEN. Make this case insensitive

SELECT actor_id, first_name, last_name 
FROM actor
WHERE last_name iLIKE '%gen%';
-- This returns all actors whose last name contains the consecutive letters GEN.

SELECT actor_id, first_name, last_name 
FROM actor
WHERE last_name similar to upper('%[gen]%');
-- This returns all actors whose last name contains the letters G, E, or N.

-- 2c. Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order. 
-- Make this case insensitive.

SELECT actor_id, first_name, last_name 
FROM actor
WHERE last_name iLIKE '%LI%'
ORDER BY last_name, first_name;


-- 2d. Using IN, display the country_id and country columns of the following countries: 
-- Afghanistan, Bangladesh, and China:

SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Add a middle_name column to the table actor. Specify the appropriate column type

ALTER TABLE actor
ADD middle_name varchar(50);

-- 3b. You realize that some of these actors have tremendously long last names. 
-- Change the data type of the middle_name column to something that can hold more than varchar.

ALTER TABLE actor 
ALTER COLUMN middle_name TYPE text;

-- 3c. Now write a query that would remove the middle_name column.

ALTER TABLE actor
DROP COLUMN middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name, count(last_name)
FROM actor
GROUP BY  last_name
ORDER BY  count(last_name) DESC;

-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors

SELECT last_name, count(last_name)
FROM actor
GROUP BY  last_name
HAVING count(last_name)>1
ORDER BY  count(last_name) DESC;

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
-- Write a query to fix the record.

UPDATE actor SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO'
        AND last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
-- It turns out that GROUCHO was the correct name after all!
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. 
-- Otherwise, change the first name to MUCHO GROUCHO, 
-- as that is exactly what the actor will be with the grievous error. 
-- BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO
-- (Hint: update the record using a unique identifier.)

UPDATE actor SET first_name =
    CASE
    WHEN first_name = 'HARPO' THEN
    'GROUCHO'
    WHEN first_name = 'GROUCHO' THEN
    'MUCHO GROUCHO'
    ELSE first_name
    END
WHERE 172 IN (actor_id);

-- 5a. 
-- What’s the difference between a left join and a right join. 

-- A LEFT JOIN returns all the records from the left table and the matched records from the right table. If there are no matches in the right table, only left records are returned.
-- A RIGHT JOIN does the same as above except starting with the right table.  

-- What about an inner join and an outer join? 

-- An INNER JOIN returns all the records where there are matching values in both tables.
-- A FULL OUTER JOIN returns all the records where there is match in either the left or right table.  


-- When would you use rank? 

-- RANK returns the ranking within an ordered partition. Ties are assigned the same rank, with the next ranking(s) skipped. So, if you have 3 items at rank 2, the next rank listed would be rank 5. Both RANK and DENSE_RANK require an ORDER BY statement.
-- RANK is useful when the number of records matters.


-- What about dense_rank? 

-- DENSE_RANK is similar to RANK except the ranks are consecutive. No ranks are skipped if there are ranks with mulitple records.
-- DENSE_RANK is useful when the number of records don't matter and only the relative positioning matter.

-- When would you use a subquery in a select? 

-- A subquery is useful to filter data further than accessible in a single query, usually when pulling data from multiple tables. The subquery filters the data that the outer select statement will query from.

-- When would you use a right join?

-- When you care about all the records from the right table and only the matched records from the left table. 

-- When would you use an inner join over an outer join?

-- You would use a INNER JOIN if you are searching for common values amongst both tables being joined.

-- What’s the difference between a left outer and a left join?

-- They are the same.

-- When would you use a group by?

-- A GROUP BY is often used with aggregate functions (COUNT, MAX, MIN, SUM, AVG) to group the result-set by one or more columns. 

-- Describe how you would do data reformatting

-- Data reformatting can be accomplished using the OVERLAY function. The OVERLAY function replaces the original string with the placing string and returns the resulting string in a new column field.
-- The original table remains unmodified and the table maintains its integrity.

-- When would you use a with clause?

-- The SQL WITH clause allows you to give a sub-query block a name, which can be referenced in several places within the main SQL query. 
-- The name assigned to the sub-query is treated as though it was an inline view. 
-- The SQL WITH clause is basically a drop-in replacement to the normal sub-query.


-- 6a. Use a JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT s.first_name,
         s.last_name,
         a.address
FROM staff s
LEFT JOIN address a
USING (address_id);

-- or alternatively:

SELECT s.first_name,
         s.last_name,
         a.address
FROM staff s
LEFT JOIN address a
    ON s.address_id = a.address_id;

-- 6b. Use a JOIN to display the total amount rung up by each staff member in January of 2007. 
-- Use tables staff and payment.

SELECT concat(s.first_name, ' ', s.last_name) AS staff_name, 
        sum(p.amount) AS jan_07_tot_payments 
FROM staff s
LEFT JOIN payment p
    ON s.staff_id = p.staff_id
WHERE extract(year from p.payment_date) = 2007
GROUP BY  s.first_name, s.last_name;

-- 6c. List each film and the number of actors who are listed for that film. 
-- Use tables film_actor and film. Use inner join.

SELECT f_a.film_id,
         f.title,
         count(f_a.actor_id)
FROM film_actor f_a
LEFT JOIN film f
USING (film_id)
GROUP BY  f_a.film_id, f.title
ORDER BY  film_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

-- hunchback film_id is 439
SELECT f.title,
         count(i.inventory_id) AS copies_of_film
FROM film f
LEFT JOIN inventory i
USING (film_id)
GROUP BY  f.title
HAVING f.title = upper('Hunchback Impossible');

-- 6e. Using the tables payment and customer and the JOIN command, 
-- list the total paid by each customer. List the customers alphabetically by last name:

SELECT concat(c.first_name, ' ', c.last_name) AS customer_name, 
        sum(p.amount) AS total_paid 
FROM customer c
LEFT JOIN payment p
    ON c.customer_id = p.customer_id
GROUP BY  c.first_name, c.last_name
ORDER BY c.last_name, c.first_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q
-- have also soared in popularity. display the titles of movies starting
-- with the letters K and Q whose language is English.

SELECT title 
FROM film
WHERE title similar to upper('[kq]%') AND language_id = 1
ORDER BY film_id;

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT concat(a.first_name, ' ', a.last_name) AS actor_name
FROM actor a 
LEFT JOIN film_actor fa
ON a.actor_id = fa.actor_id
LEFT JOIN film f
ON fa.film_id = f.film_id
WHERE upper('Alone Trip') IN (f.title);

-- 7c. You want to run an email marketing campaign in Canada, 
-- for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.

SELECT cu.first_name,
         cu.last_name,
         cu.email
FROM customer cu
LEFT JOIN address a
    ON cu.address_id = a.address_id
LEFT JOIN city cy
    ON a.city_id = cy.city_id
LEFT JOIN country co
    ON cy.country_id = co.country_id
WHERE co.country = 'Canada';

-- 7d. Sales have been lagging among young families, 
-- and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as a family film.

SELECT title
FROM film
WHERE rating IN ('G', 'PG');

-- 7e. Display the most frequently rented movies in descending order.

SELECT f.title,
         count(r.rental_id) AS rental_count
FROM film f
LEFT JOIN inventory i
    ON f.film_id = i.film_id
LEFT JOIN rental r
    ON i.inventory_id = r.inventory_id
GROUP BY  f.title
ORDER BY  count(r.rental_id) DESC;


-- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT s.store_id,
         sum(p.amount)
FROM store s
LEFT JOIN staff sf
    ON s.store_id = sf.store_id
LEFT JOIN payment p
    ON sf.staff_id = p.staff_id
GROUP BY  s.store_id
ORDER BY  s.store_id; 

-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT s.store_id,
         cy.city,
         co.country
FROM store s
LEFT JOIN address a
    ON s.address_id = a.address_id
LEFT JOIN city cy
    ON a.city_id = cy.city_id
LEFT JOIN country co
    ON cy.country_id = co.country_id;

-- 7h. List the top five genres in gross revenue in descending order. 

SELECT cat.name,
         sum(pay.amount)
FROM category cat
LEFT JOIN film_category fc
    ON cat.category_id = fc.category_id
LEFT JOIN film f
    ON fc.film_id = f.film_id
LEFT JOIN inventory i
    ON f.film_id = i.film_id
LEFT JOIN rental r
    ON i.inventory_id = r.inventory_id
LEFT JOIN payment pay
    ON r.rental_id = pay.rental_id
GROUP BY  cat.name
ORDER BY  sum(pay.amount) DESC limit 5;

-- 8a. In your new role as an executive, you would like to have an 
-- easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. 

CREATE OR REPLACE VIEW top_five_genres AS
SELECT cat.name,
         sum(pay.amount)
FROM category cat
LEFT JOIN film_category fc
    ON cat.category_id = fc.category_id
LEFT JOIN film f
    ON fc.film_id = f.film_id
LEFT JOIN inventory i
    ON f.film_id = i.film_id
LEFT JOIN rental r
    ON i.inventory_id = r.inventory_id
LEFT JOIN payment pay
    ON r.rental_id = pay.rental_id
GROUP BY  cat.name
ORDER BY  sum(pay.amount) DESC limit 5;

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM top_five_genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW top_five_genres;