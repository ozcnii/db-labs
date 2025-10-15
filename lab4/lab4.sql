use sakila;

-- 1. Вывести всех покупателей из указанного списка стран: отобразить имя,
-- фамилию, страну. ('Argentina', 'Brazil', 'Russian Federation')

SELECT c.first_name, c.last_name, co.country
FROM
    customer c
    JOIN address a ON c.address_id = a.address_id
    JOIN city ci ON a.city_id = ci.city_id
    JOIN country co ON ci.country_id = co.country_id
WHERE
    co.country IN (
        'Argentina',
        'Brazil',
        'Russian Federation'
    );

-- 2. Вывести все фильмы, в которых снимался указанный актер: отобразить название
-- фильма, жанр. (PENELOPE GUINESS)

SELECT f.title, c.name AS category
FROM
    film f
    JOIN film_actor fa ON f.film_id = fa.film_id
    JOIN actor a ON fa.actor_id = a.actor_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
WHERE
    a.first_name = 'PENELOPE'
    AND a.last_name = 'GUINESS';

-- 3. Вывести топ 10 жанров фильмов по величине дохода в указанном месяце ('2005-05-01' - '2005-05-31'):
-- отобразить жанр, доход.

SELECT c.name, SUM(p.amount) AS revenue
FROM
    payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film_category fc ON i.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
WHERE
    p.payment_date BETWEEN '2005-05-01' AND '2005-05-31'
GROUP BY
    c.name
ORDER BY revenue DESC
LIMIT 10;

-- 4. Вывести список из 5 клиентов, упорядоченный по количеству купленных
-- фильмов с указанным актером (SANDRA KILMER), начиная с 10-й позиции: отобразить имя,
-- фамилию, количество купленных фильмов.

SELECT c.first_name, c.last_name, COUNT(f.film_id) AS film_count
FROM
    customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_actor fa ON f.film_id = fa.film_id
    JOIN actor a ON fa.actor_id = a.actor_id
WHERE
    a.first_name = 'SANDRA'
    AND a.last_name = 'KILMER'
GROUP BY
    c.customer_id
ORDER BY film_count DESC
LIMIT 5
OFFSET
    9;

-- 5. Вывести для каждого магазина его город, страну расположения и суммарный
-- доход за первую неделю продаж.

SELECT s.store_id, ci.city, co.country, SUM(p.amount) AS total_revenue
FROM
    store s
    JOIN address a ON s.address_id = a.address_id
    JOIN city ci ON a.city_id = ci.city_id
    JOIN country co ON ci.country_id = co.country_id
    JOIN staff st ON s.store_id = st.store_id
    JOIN payment p ON st.staff_id = p.staff_id
WHERE
    p.payment_date BETWEEN (
        SELECT MIN(payment_date)
        FROM payment
    ) AND DATE_ADD(
        (
            SELECT MIN(payment_date)
            FROM payment
        ),
        INTERVAL 7 DAY
    )
GROUP BY
    s.store_id,
    ci.city,
    co.country;

-- 6. Вывести всех актеров для фильма, принесшего наибольший доход: отобразить
-- фильм, имя актера, фамилия актера.

SELECT f.title, a.first_name, a.last_name
FROM
    film f
    JOIN film_actor fa ON f.film_id = fa.film_id
    JOIN actor a ON fa.actor_id = a.actor_id
WHERE
    f.film_id = (
        SELECT f.film_id
        FROM
            payment p
            JOIN rental r ON p.rental_id = r.rental_id
            JOIN inventory i ON r.inventory_id = i.inventory_id
            JOIN film f ON i.film_id = f.film_id
        GROUP BY
            f.film_id
        ORDER BY SUM(p.amount) DESC
        LIMIT 1
    );

-- 7. Для всех покупателей вывести информацию о покупателях и актерах-
-- однофамильцах (используя LEFT JOIN, если однофамильцев нет – вывести
-- NULL).

SELECT
    c.first_name AS customer_first_name,
    c.last_name AS customer_last_name,
    a.first_name AS actor_first_name,
    a.last_name AS actor_last_name
FROM customer c
    LEFT JOIN actor a ON c.last_name = a.last_name;

-- 8. Для всех актеров вывести информацию о покупателях и актерах-однофамильцах
-- (используя RIGHT JOIN, если однофамильцев нет – вывести NULL).

SELECT
    c.first_name AS customer_first_name,
    c.last_name AS customer_last_name,
    a.first_name AS actor_first_name,
    a.last_name AS actor_last_name
FROM customer c
    RIGHT JOIN actor a ON c.last_name = a.last_name;

-- 9. В одном запросе вывести статистические данные о фильмах:
--      10. 11.1. Длина самого продолжительного фильма – отобразить значение длины;
--      количество фильмов, имеющих такую продолжительность.

--      11. 11.2. Длина самого короткого фильма – отобразить значение длины; количество
--      фильмов, имеющих такую продолжительность.

--      12. 11.3. Максимальное количество задействованных актеров в фильме – отобразить
--      максимальное количество актеров; количество фильмов, имеющих такое число
--      актеров.

--      13. 11.4. Минимальное количество задействованных актеров в фильме - отобразить
--      минимальное количество актеров; количество фильмов, имеющих такое число
--      актеров.

SELECT
    MAX(length) AS max_duration,
    (
        SELECT COUNT(*)
        FROM film
        WHERE
            length = MAX(f.length)
    ) AS films_with_max_duration,
    MIN(length) AS min_duration,
    (
        SELECT COUNT(*)
        FROM film
        WHERE
            length = MIN(f.length)
    ) AS films_with_min_duration,
    MAX(actor_count) AS max_actors,
    (
        SELECT COUNT(*)
        FROM (
                SELECT COUNT(actor_id) AS actor_count
                FROM film_actor
                GROUP BY
                    film_id
            ) AS counts
        WHERE
            actor_count = MAX(ac.actor_count)
    ) AS films_with_max_actors,
    MIN(actor_count) AS min_actors,
    (
        SELECT COUNT(*)
        FROM (
                SELECT COUNT(actor_id) AS actor_count
                FROM film_actor
                GROUP BY
                    film_id
            ) AS counts
        WHERE
            actor_count = MIN(ac.actor_count)
    ) AS films_with_min_actors
FROM film f, (
        SELECT film_id, COUNT(actor_id) AS actor_count
        FROM film_actor
        GROUP BY
            film_id
    ) ac;