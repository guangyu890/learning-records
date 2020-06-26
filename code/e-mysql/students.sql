-- Table_name: students_tbl
-- Author: 小雨漫
-- Update: 2020-06-25
-- 操作数据表的方法：
-- 1.查看表结构（列出的所有字段名）
SHOW COLUMNS FROM table_name;
-- 2.插入数据方法：
-- 自增字段可以不添加插入，会自行增加
-- 按字段名添加数据
INSERT INTO table_name (column_name1, column_name2, column_name3, ...) VALUES (`按照字段数据类型分别插入`);

-- 不按字段名添加
INSERT INTO table_name VALUES ('须按字段依次添加数据');
------------------------------
CREATE TABLE IF NOT EXISTS  `students_tbl`(
    `students_id` BIGINT UNSIGNED AUTO_INCREMENT,
    `class_id` BIGINT NOT NULL,
    `students_name`  VARCHAR(30) NOT NULL,
    `students_gender` CHAR(2) NOT NULL,
    `students_score` INT NOT NULL,
    PRIMARY KEY(`students_id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
