use sakila;

-- Query 1:
-- 		What are the names of all the languages in the database (sorted alphabetically)?

select l.name 
from language l
order by l.name asc;

-- Query 2:
-- 		Return the full names (first and last) of actors with “SON” in their last name, ordered by their first name.

select CONCAT(first_name, ' ', last_name) as full_name 
from actor
-- where last_name REGEXP '.*SON.*' 
where last_name like '%SON%'
order by first_name asc;

-- Query 3:
-- 		Find all the addresses where the district is not empty (i.e., contains some text), and return
-- 		these districts sorted.

select address, district
from address
where district is not null and district not like '' 
order by district;

-- Query 4:
-- 		Return the first and last names of actors who played in a film involving a “Crocodile” and a “Shark”,
-- 		along with the release year of the movie, sorted by the actors’ last names.

select a.first_name, a.last_name, f.release_year, f.title, f.description
from film_actor fa
    inner join film f on fa.film_id = f.film_id
    inner join actor a on fa.actor_id = a.actor_id
where CONCAT(f.title, ' ', f.description) like '%crocodile%' 
and CONCAT(f.title, ' ', f.description) like '%shark%'
order by a.last_name asc;

-- Query 5:
-- 		How many films involve a “Crocodile” and a “Shark”?

select count(*)
from film f
where CONCAT(f.title, ' ', f.description) like '%crocodile%' 
and CONCAT(f.title, ' ', f.description) like '%shark%';

-- Query 6:
-- 		What is the average running time of films by category?

select fc.category_id, avg(length) as avg_running_time
from film f, film_category fc
where  f.film_id = fc.film_id
group by fc.category_id;

-- Query 7:
-- 		Which actor has appeared in the most films?

select a.actor_id, a.first_name, a.last_name, film_count
from
    (select actor_id, count(*) as film_count
    from film_actor fa
    group by fa.actor_id) as fa inner join actor a on fa.actor_id = a.actor_id
order by film_count desc limit 1;

-- Query 8:
-- 		When is each copy(inventory) of ‘Academy Dinosaur’ due?

select inventory_id, max(return_date)
from rental
where inventory_id in (
    select inventory_id
    from inventory
    where film_id = (
        select film_id
        from film
        where title = 'Academy Dinosaur'
    )
)
group by inventory_id;

-- Query 9:
-- 		Find all the film categories in which there are between 55 and 65 films. Return the names of these
-- 		categories and the number of films per category, sorted by the number of films.

select category.name as category_name, film_count
from (select category_id, count(*) as film_count
		from film_category
	  group by category_id) as film_category inner join category on category.category_id = film_category.category_id
where film_count > 55 and film_count < 65
order by film_count asc;

-- Query 10:
-- 		In how many film categories is the average difference between the film replacement cost and the
-- 		rental rate larger than 17?

select count(*)
from (
    select name, avg(replacement_rental_diff) as avg_replacement_rental_diff
    from (
        select category.name, (replacement_cost - rental_rate) as replacement_rental_diff
        from film_category
            inner join film on film.film_id = film_category.film_id
            inner join category on category.category_id = film_category.category_id
    ) as replacement
    group by name
) as replacement_avg
where avg_replacement_rental_diff > 17

