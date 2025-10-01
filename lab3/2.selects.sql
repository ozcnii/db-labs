-- 1) + Запрос на выборку избранных полей таблицы, с использованием синонима (алиаса) и сортировкой записей (ORDER BY).

SELECT
    st.last_name AS Фамилия,
    st.first_name AS Имя,
    st.birthdate AS `Дата рождения`
FROM `mydb`.`Students` AS st
ORDER BY st.last_name ASC;

-- 2) + Запрос с использованием сортировки (ORDER BY) и группировки (GROUP BY).

SELECT
    sg.name AS group_name,
    COUNT(s.student_id) AS number_of_students
FROM `mydb`.`Students` s
JOIN `mydb`.`StundentGroups` sg ON s.group_id = sg.group_id
GROUP BY sg.name
ORDER BY number_of_students DESC;

-- 3) Запрос с использованием предложения DISTINCT.

SELECT DISTINCT
    s.sex
FROM `mydb`.`Students` s;

-- 4) Запрос с использованием операций сравнения.

SELECT
    name,
    total_hours
FROM `mydb`.`Subjects`
WHERE total_hours > 150;

-- 5) Запросы для предикатов: IN, BETWEEN, LIKE, IS NULL.

-- IN
SELECT last_name, first_name, group_id
FROM `mydb`.`Students`
WHERE group_id IN (1, 3, 5);

-- BETWEEN
SELECT name, course, semester
FROM `mydb`.`StundentGroups`
WHERE course BETWEEN 2 AND 4;

-- LIKE
SELECT last_name, first_name
FROM `mydb`.`Students`
WHERE last_name LIKE 'Ива%';

-- IS NULL
SELECT name
FROM `mydb`.`Subjects`
WHERE total_hours IS NULL;

-- 6) Запросы с использованием агрегатных функций (COUNT, SUM, AVG,
-- MAX, MIN ), производящие обобщенную групповую обработку
-- значений полей (используя ключевые фразы GROUP BY и HAVING).

SELECT
    sg.name AS group_name,
    AVG(g.grade_value) AS average_grade,
    MAX(g.grade_value) AS max_grade,
    MIN(g.grade_value) AS min_grade
FROM `mydb`.`Students` s
JOIN `mydb`.`StundentGroups` sg ON s.group_id = sg.group_id
JOIN `mydb`.`Grades` g ON s.student_id = g.student_id
GROUP BY sg.name
HAVING AVG(g.grade_value) > 4.0;

-- 7) Запрос на выборку данных из двух связанных таблиц. Выбрать
-- несколько полей, по которым сортируется вывод.

SELECT
    s.last_name,
    s.first_name,
    sg.name AS group_name
FROM `mydb`.`Students` s
JOIN `mydb`.`StundentGroups` sg ON s.group_id = sg.group_id
ORDER BY sg.name, s.last_name;

-- 8) Многотабличный запрос с использованием внутреннего и внешнего
-- соединения.

-- INNER JOIN
SELECT s.last_name, sub.name, g.grade_value
FROM `mydb`.`Students` s
INNER JOIN `mydb`.`Grades` g ON s.student_id = g.student_id
INNER JOIN `mydb`.`Subjects` sub ON g.subject_id = sub.subject_id;

-- LEFT OUTER JOIN (показать всех студентов, даже тех, у кого нет оценок)
SELECT s.last_name, s.first_name, g.grade_value
FROM `mydb`.`Students` s
LEFT OUTER JOIN `mydb`.`Grades` g ON s.student_id = g.student_id;

-- 9) Многотабличный запрос с использованием оператора UNION.
-- Выбрать студентов из 1 и 3 курсов
SELECT s.last_name, s.first_name, sg.course
FROM `mydb`.`Students` s
JOIN `mydb`.`StundentGroups` sg ON s.group_id = sg.group_id
WHERE sg.course = 1
UNION
SELECT s.last_name, s.first_name, sg.course
FROM `mydb`.`Students` s
JOIN `mydb`.`StundentGroups` sg ON s.group_id = sg.group_id
WHERE sg.course = 3;

-- 10) Запрос с применением подзапроса в части WHERE команды SQL
-- SELECT и в внутри предложения HAVING.

SELECT last_name, first_name
FROM `mydb`.`Students`
WHERE group_id IN (SELECT group_id FROM `mydb`.`StundentGroups` WHERE course = 1);


-- 11) Запрос с применением подзапроса с применением следующих
-- операторов: ALL, EXIST, ANY.

-- ANY (найти студентов, у которых есть хотя бы одна оценка выше, чем любая оценка студента с id=2)
SELECT last_name, first_name FROM `mydb`.`Students`
WHERE student_id IN (
    SELECT student_id FROM `mydb`.`Grades`
    WHERE grade_value > ANY (SELECT grade_value FROM `mydb`.`Grades` WHERE student_id = 2)
    AND student_id != 2
);

-- ALL (Найти всех студентов, которые учатся НЕ в группах, чье название начинается с "ИВТ".
SELECT s.last_name, s.first_name, sg.name
FROM `mydb`.`Students` s
JOIN `mydb`.`StundentGroups` sg ON s.group_id = sg.group_id
WHERE s.group_id != ALL (
    SELECT group_id FROM `mydb`.`StundentGroups` WHERE name LIKE 'ИВТ%'
);

-- EXISTS (найти группы, в которых есть студенты)
SELECT name FROM `mydb`.`StundentGroups` sg
WHERE EXISTS (SELECT 1 FROM `mydb`.`Students` s WHERE s.group_id = sg.group_id);
