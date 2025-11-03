USE examination_results;

-- 1. Создать два не обновляемых представления, возвращающих пользователю
-- результат из нескольких таблиц, с разными алгоритмами обработки
-- представления.

-- Критерии обновляемости представления:
-- 1. Отсутствие функций агрегации в представлении.
-- 2. Отсутствие следующих выражений в представлении: DISTINCT, GROUP BY, HAVING, UNION.
-- 3. Отсутствие подзапросов в списке выражения SELECT
-- 4. Колонки представления быть простыми ссылками на поля таблиц (а не, например,
-- арифметическими выражениями) и т.д. 

-- 1.1 Сведения об оценках студентов (join)
CREATE OR REPLACE VIEW Student_Subject_Grades AS
SELECT 
    s.first_name,
    s.last_name,
    sub.subject_name,
    g.grade_value
FROM
    Students AS s
JOIN
    Grades AS g ON s.student_id = g.student_id
JOIN
    Subjects AS sub ON g.subject_id = sub.subject_id;

SELECT * FROM Student_Subject_Grades;

-- 1.2 Средний балл каждого студента (group by)

CREATE OR REPLACE VIEW Student_Average_Grade AS
SELECT
    s.first_name,
    s.last_name,
    AVG(g.grade_value) AS average_grade
FROM
    Students AS s
JOIN
    Grades AS g ON s.student_id = g.student_id
GROUP BY
    s.student_id;

SELECT * FROM Student_Average_Grade;




-- 2. Создать обновляемое представление, не позволяющее выполнить команду INSERT

CREATE OR REPLACE VIEW Student_FullNames AS
SELECT
    student_id,
    first_name,
    middle_name,
    last_name
FROM
    Students;

-- INSERT не сработает, так как мы не передаем значение для date_of_birth (обязательное поле):
-- INSERT INTO Student_FullNames (first_name, last_name) VALUES ('Новый', 'Студент');




-- 3. Создать обновляемое представление, позволяющее выполнить команду INSERT.

CREATE OR REPLACE VIEW Instructors_View AS
SELECT
    instructor_id,
    last_name,
    first_name,
    middle_name
FROM
    Instructors;




-- 4. Создать вложенное обновляемое представление с проверкой ограничений (WITH CHECK OPTION).
-- представление для предметов, которые читаются в первом семестре

CREATE OR REPLACE VIEW Semester1_Subjects AS
SELECT
    subject_id,
    subject_name,
    semester,
    instructor_id
FROM
    Subjects
WHERE
    semester = 1
WITH CHECK OPTION;
