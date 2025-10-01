-- Активация созданной базы данных для дальнейших операций
USE `examination_results`;

-- 1) Вывод всех предметов, упорядоченных по алфавиту.
SELECT `subject_name` AS 'Название предмета'
FROM `Subjects`
ORDER BY `subject_name`;

-- 2) Вывод количества студентов.

SELECT COUNT(`student_id`) as `Общее количество студентов`
FROM `Students`;

-- 3) Вывод студентов, чья фамилия начинается на «Ива».

SELECT *
FROM `Students`
WHERE `last_name` LIKE 'Ива%';

-- 4) Вывод студентов (фамилий), получивших оценки 5 по указанному
-- предмету, упорядоченных по алфавиту в обратном порядке.
-- !!! Указанный предмет: "Базы данных" (subject_id = 201)

SELECT `last_name`
FROM `Students` as STUD
JOIN `Grades` as G ON STUD.`student_id` = G.`student_id`
JOIN `Subjects` as SUBJ ON G.`subject_id` = SUBJ.`subject_id`
WHERE G.`grade_value` = 5 AND SUBJ.`subject_id` = 201
ORDER BY `last_name` DESC;


-- 5) Вывод студентов, набравших более 12 баллов по трем предметам (три
-- выбранных предмета - у всех студентов должны быть одинаковыми).
-- !!! Выбранные предметы: 
-- 		- "Базы данных" 			(subject_id = 201), 
-- 		- "Программирование" 		(subject_id = 202), 
-- 		- "Операционные системы" 	(subject_id = 205)

SELECT STUD.`student_id`, SUM(G.`grade_value`) as 'Сумма оценок'
FROM `Students` as STUD
JOIN `Grades` as G ON STUD.`student_id` = G.`student_id`
JOIN `Subjects` as SUBJ ON G.`subject_id` = SUBJ.`subject_id`
WHERE SUBJ.`subject_id` IN (201, 202, 205)
GROUP BY STUD.`student_id`
HAVING SUM(G.`grade_value`) > 12 AND COUNT(DISTINCT G.`subject_id`) = 3;

