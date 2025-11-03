USE examination_results;

-- 5.
-- Выберите любую таблицу, созданную в предыдущих лабораторных работах.
-- Создайте транзакцию, произведите ее откат и фиксацию:
-- a. Отключите режим автоматического завершения;
-- b. Добавьте в выбранную таблицу новые записи, проверьте добавились ли они;
-- c. Произведите откат транзакции, т. е. отмену произведенных действий;
-- d. Откатите транзакцию оператором ROLLBACK(изменения не
-- сохранились);
-- e. Воспроизведите транзакцию и сохраните действия оператором
-- COMMIT.

-- a
SET autocommit = 0;

-- b
START TRANSACTION;
INSERT INTO Instructors (instructor_id, last_name, first_name, middle_name) VALUES (205, 'Тестовый', 'Преподаватель', 'Тестовый');
SELECT * FROM Instructors WHERE last_name = 'Тестовый';

-- c, d
ROLLBACK;
SELECT * FROM Instructors WHERE last_name = 'Тестовый';

-- e
START TRANSACTION;
INSERT INTO Instructors (instructor_id, last_name, first_name, middle_name) VALUES (205, 'Тестовый', 'Преподаватель', 'Тестовый');
COMMIT;

SELECT * FROM Instructors WHERE last_name = 'Тестовый';




-- 6.
-- Продемонстрировать возможность чтения незафиксированных изменений при
-- использовании уровня изоляции READ UNCOMMITTED и отсутствие такой
-- возможности при уровне изоляции READ COMMITTED

-- 6.1 (грязное чтение)

-- окно 1
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
UPDATE Students SET first_name = 'Алексей' WHERE student_id = 1001;
-- COMMIT пока не делаем!

-- окно 2
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
SELECT first_name FROM Students WHERE student_id = 1001;
COMMIT;

-- окно 1
ROLLBACK; 


-- 6.2 (защита от грязного чтения)

-- окно 1
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
UPDATE Students SET first_name = 'Сергей' WHERE student_id = 1001;

-- окно 2
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT first_name FROM Students WHERE student_id = 1001;
COMMIT;

-- окно 1
COMMIT; 

-- окно 2
SELECT first_name FROM Students WHERE student_id = 1001;


-- 7.
-- Продемонстрировать возможность записи в уже прочитанные данные при
-- использовании уровня изоляции READ COMMITTED и отсутствие такой
-- возможности при уровне изоляции REPEATABLE READ 

-- 7.1 (возможность записи в уже прочитанные данные)

-- окно 1
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT * FROM Students WHERE student_id = 1002;

-- окно 2
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
UPDATE Students SET first_name = 'Елена' WHERE student_id = 1002;
COMMIT; -- сразу же сохраняем изменения

-- окно 1
SELECT * FROM Students WHERE student_id = 1002; -- имя изменилось


-- 7.2 (отсутствие возможности записи в уже прочитанные данные)

-- окно 1
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT * FROM Students WHERE student_id = 1002;

-- окно 2
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
UPDATE Students SET first_name = 'Ольга' WHERE student_id = 1002;
COMMIT;

-- окно 1
SELECT * FROM Students WHERE student_id = 1002; -- имя не изменилось