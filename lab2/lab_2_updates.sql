-- Активация созданной базы данных для дальнейших операций
USE `examination_results`;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE `Grades`;
TRUNCATE TABLE `Subjects`;
TRUNCATE TABLE `Students`;
TRUNCATE TABLE `Instructors`;
SET FOREIGN_KEY_CHECKS = 1;


INSERT INTO `Instructors` (`instructor_id`, `last_name`, `first_name`, `middle_name`) VALUES
(101, 'Иванов', 'Иван', 'Иванович'),
(102, 'Петрова', 'Анна', 'Сергеевна'),
(103, 'Сидоров', 'Виктор', 'Николаевич');

INSERT INTO `Students` (`student_id`, `last_name`, `first_name`, `middle_name`, `date_of_birth`) VALUES
(1001, 'Иванов', 'Александр', 'Сергеевич', '2003-05-15'),
(1002, 'Петрова', 'Мария', 'Игоревна', '2002-11-20'),
(1003, 'Сидоров', 'Дмитрий', 'Владимирович', '2003-01-01'),
(1004, 'Ковалева', 'Анна', 'Павловна', '2004-03-25'),
(1005, 'Иванова', 'Екатерина', 'Олеговна', '2002-09-10'),
(1006, 'Смирнов', 'Сергей', 'Андреевич', '2003-07-07');

INSERT INTO `Subjects` (`subject_id`, `subject_name`, `semester`, `instructor_id`) VALUES
(201, 'Базы данных', 3, 101),
(202, 'Программирование', 3, 102),
(203, 'Дискретная математика', 2, 103),
(204, 'Физика', 2, 101),
(205, 'Операционные системы', 3, 102);

INSERT INTO `Grades` (`student_id`, `subject_id`, `grade_value`) VALUES
(1001, 201, 5),
(1001, 202, 5),
(1001, 205, 4),

(1002, 201, 3),
(1002, 203, 4),
(1002, 204, 3),

(1003, 201, 5),
(1003, 202, 4),
(1003, 203, 5),

(1004, 201, 5),
(1004, 202, 3),
(1004, 204, 2),
(1004, 205, 3),

(1005, 201, 4),
(1005, 202, 4),
(1005, 205, 5),

(1006, 203, 2),
(1006, 204, 1);


UPDATE `Students`
SET `first_name` = 'Александра', `middle_name` = 'Геннадьевна'
WHERE `student_id` = 1001;

UPDATE `Grades`
SET `grade_value` = 4
WHERE `student_id` = 1002 AND `subject_id` = 201;

DELETE FROM `Students`
WHERE `student_id` = 1006;

DELETE FROM `Subjects`
WHERE `subject_id` = 204; -- Предмет "Физика"