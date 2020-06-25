-- Table_name: classes
-- Author: 小雨漫
-- Update: 2020-6-25
CREATE TABLE IF NOT EXISTS `classes_tbl`(
   `classes_id` BIGINT UNSIGNED AUTO_INCREMENT,
   `classes_name` VARCHAR(30) NOT NULL,
   PRIMARY KEY(`classes_id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;