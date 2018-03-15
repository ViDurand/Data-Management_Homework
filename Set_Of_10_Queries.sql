
-- Query 1:
-- 		What are the names of all the languages in the database (sorted alphabetically)?
select name from language


-- Query 2:
-- 		Return the full names (first and last) of actors with “SON” in their last name, ordered by their first name.
select CONCAT(first_name, ' ', last_name) as full_name from actor where last_name REGEXP '.*SON$' order by first_name asc



-- Query 3:
-- 		Find all the addresses where the second address is not empty (i.e., contains some text), and return
-- 		these second addresses sorted.
select address from address  where address2 is not null order by address2


-- Query 4:
-- 		Return the first and last names of actors who played in a film involving a “Crocodile” and a “Shark”,
-- 		along with the release year of the movie, sorted by the actors’ last names.
select first_name, last_name, release_year, title
from film_actor
    inner join film on film_actor.film_id = film.film_id
    inner join actor on film_actor.actor_id = actor.actor_id
where title REGEXP 'AFRICA' and title REGEXP 'EGG'
order by last_name asc



-- Query 5:
-- 		How many films involve a “Crocodile” and a “Shark”?
select count(*)
from film
where title REGEXP 'AFRICA' and title REGEXP 'EGG'


-- Query 6:
-- 		What is the average running time of films by category?
select release_year, avg(length)
from film
group by release_year


-- Query 7:
-- 		Which actor has appeared in the most films?
select actor.actor_id, first_name, last_name, film_count
from
    (select actor_id, count(*) as film_count
    from film_actor
    group by actor_id) as film_actor inner join actor on film_actor.actor_id = actor.actor_id
order by film_count desc limit 1


-- Query 8:
-- 		When is ‘Academy Dinosaur’ due?
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
group by inventory_id



-- Query 9:
-- 		Find all the film categories in which there are between 55 and 65 films. Return the names of these
-- 		categories and the number of films per category, sorted by the number of films.
select name, film_count
from (select category_id, count(*) as film_count
    from film_category
    group by category_id) as film_category inner join category on category.category_id = film_category.category_id
where film_count > 55 and film_count < 65
order by film_count asc



-- Query 10:
-- 		In how many film categories is the average difference between the film replacement cost and the
-- 		rental rate larger than 17?
select count(*)
from (
    select name, avg(replacement_diff) as avg_cost
    from (
        select category.name, (replacement_cost - rental_rate) as replacement_diff
        from film_category
            inner join film on film.film_id = film_category.film_id
            inner join category on category.category_id = film_category.category_id
    ) as replacement
    group by name
) as replacement_avg
where avg_cost > 17
