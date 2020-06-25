-- Table_name: students_tbl
-- Author: 小雨漫
-- Update: 2020-06-25
CREATE TABLE IF NOT EXISTS  `students_tbl`(
    `students_id` BIGINT UNSIGNED AUTO_INCREMENT,
    `class_id`,
    `students_name`  VARCHAR(30) NOT NULL,
    `students_gender` CHAR(2) NOT NULL,
    `students_score` INT NOT NULL,
    PRIMARY KEY(`students_id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;