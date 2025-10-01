-- 1) выбрать успеваемость студента по дисциплинам с указанием общего
-- количества часов и вида контроля; (student_id = 1)

SELECT
    s.last_name,
    s.first_name,
    sub.name AS subject_name,
    g.grade_value,
    sub.total_hours,
    sub.control_type
FROM `mydb`.`Students` s
JOIN `mydb`.`Grades` g ON s.student_id = g.student_id
JOIN `mydb`.`Subjects` sub ON g.subject_id = sub.subject_id
WHERE s.student_id = 1;

-- 2) + выбрать успеваемость студентов по группам и дисциплинам;
-- 		1) Запрос на выборку избранных полей таблицы, с использованием синонима (алиаса) и сортировкой записей (ORDER BY).
SELECT
    sg.name AS group_name,
    sub.name AS subject_name,
    s.last_name,
    s.first_name,
    g.grade_value
FROM `mydb`.`Students` s
JOIN `mydb`.`StundentGroups` sg ON s.group_id = sg.group_id
JOIN `mydb`.`Grades` g ON s.student_id = g.student_id
JOIN `mydb`.`Subjects` sub ON g.subject_id = sub.subject_id
ORDER BY sg.name, sub.name, s.last_name;

-- 3) + выбрать группы, в которых у студентов в настоящее время наибольшая
-- успеваемость;
-- 		2) Запрос с использованием сортировки (ORDER BY) и группировки (GROUP BY).
SELECT
    sg.name AS group_name,
    AVG(g.grade_value) AS average_grade
FROM `mydb`.`Students` s
JOIN `mydb`.`StundentGroups` sg ON s.group_id = sg.group_id
JOIN `mydb`.`Grades` g ON s.student_id = g.student_id
GROUP BY sg.name
ORDER BY average_grade DESC;

-- 4) выбрать дисциплины, по которым у студентов в настоящее время наибольшая
-- успеваемость;
SELECT
    sub.name AS sub_name,
    AVG(g.grade_value) AS average_grade
FROM `mydb`.`Students` s
JOIN `mydb`.`Grades` g ON s.student_id = g.student_id
JOIN `mydb`.`Subjects` sub ON g.subject_id = sub.subject_id
GROUP BY sub.`name`
ORDER BY average_grade DESC;

-- 5) выбрать возраст студентов, у которых в настоящее время наибольшая
-- успеваемость;
SELECT
    s.last_name,
    s.first_name,
    TIMESTAMPDIFF(YEAR, s.birthdate, CURDATE()) AS age,
    AVG(g.grade_value) as average_grade
FROM `mydb`.`Students` s
JOIN `mydb`.`Grades` g ON s.student_id = g.student_id
GROUP BY s.student_id
ORDER BY average_grade DESC;

-- 6) выбрать дисциплины, изучаемые группой студентов на определенном курсе
-- или определенном семестре;
SELECT DISTINCT
    sub.name AS subject_name
FROM `mydb`.`Subjects` sub
JOIN `mydb`.`Grades` g ON sub.subject_id = g.subject_id
JOIN `mydb`.`Students` s ON g.student_id = s.student_id
JOIN `mydb`.`StundentGroups` sg ON s.group_id = sg.group_id
WHERE sg.course = 2; -- или sg.semester = 4

-- 7) выбрать дисциплины, которые не изучаются студентами в настоящий момент.
SELECT
    sub.name AS subject_name
FROM `mydb`.`Subjects` sub
LEFT JOIN `mydb`.`Grades` g ON sub.subject_id = g.subject_id
WHERE g.subject_id IS NULL;


