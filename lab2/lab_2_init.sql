-- Создание базы данных для сведений о результатах экзаменационной сессии
CREATE DATABASE IF NOT EXISTS `examination_results`;

-- Активация созданной базы данных для дальнейших операций
USE `examination_results`;

-- DROP TABLE IF EXISTS `Grades`;
-- DROP TABLE IF EXISTS `Subjects`;
-- DROP TABLE IF EXISTS `Students`;
-- DROP TABLE IF EXISTS `Instructors`;

-- Таблица: Студенты
CREATE TABLE IF NOT EXISTS `Students` (
    `student_id` INT NOT NULL,
    `last_name` VARCHAR(100) NOT NULL,
    `first_name` VARCHAR(100) NOT NULL,
    `middle_name` VARCHAR(100),
    `date_of_birth` DATE,
    PRIMARY KEY (`student_id`)
);

-- Таблица: Преподаватели
CREATE TABLE IF NOT EXISTS `Instructors` (
    `instructor_id` INT NOT NULL,
    `last_name` VARCHAR(100) NOT NULL,
    `first_name` VARCHAR(100) NOT NULL,
    `middle_name` VARCHAR(100),
    PRIMARY KEY (`instructor_id`)
);

-- Таблица: Предметы
CREATE TABLE IF NOT EXISTS `Subjects` (
    `subject_id` INT NOT NULL,
    `subject_name` VARCHAR(255) NOT NULL,
    `semester` INT NOT NULL,
    `instructor_id` INT NOT NULL,
    PRIMARY KEY (`subject_id`),
    CONSTRAINT `fk_subjects_instructors`
        FOREIGN KEY (`instructor_id`)
        REFERENCES `Instructors` (`instructor_id`)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Таблица: Оценки
CREATE TABLE IF NOT EXISTS `Grades` (
    `student_id` INT NOT NULL,
    `subject_id` INT NOT NULL,
    `grade_value` INT NOT NULL,
    PRIMARY KEY (`student_id`, `subject_id`),
    CONSTRAINT `fk_grades_students`
        FOREIGN KEY (`student_id`)
        REFERENCES `Students` (`student_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `fk_grades_subjects`
        FOREIGN KEY (`subject_id`)
        REFERENCES `Subjects` (`subject_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);