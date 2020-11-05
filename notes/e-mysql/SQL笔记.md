# SQL笔记

* 目标。熟悉使用SQL语句对关系型数据库进行查、改、增、删操作，利用所学知识根据业务场景创建数据库。
* 重点。语句查询、修改，函数应用等。
* 参考。廖雪峰的官方网站SQL教程、菜鸟教程等。

***

## 一、数据类型

对于一个关系表，除了定义每一列的名称外，还需定义每一列的数据类型，以下是关系数据库支持的标准数据类型：

| 名称            | 类型       | 说明                                                         |
| --------------- | ---------- | ------------------------------------------------------------ |
| INT             | 整型       | 4个字节整数类型，约为正负21亿                                |
| BIGINT          | 长整型     | 8个字节整数类型，约922亿亿                                   |
| REAL（FLOAT）   | 浮点型     | 4字节浮点数                                                  |
| DOUBLE          | 浮点型     | 8字节浮点数                                                  |
| DECIMAL（M，N） | 高数度小数 | DECIMAL（20,10）表示一共20位，其中小数10位，通常用于财务计算 |
| CHAR（N）       | 定长字符串 | CHAR（100）总是存储100个字符的字符串                         |
| VARCHAR（N）    | 变长字符串 | VARCHAR（100）可以存储0～100个字符的字符串                   |
| BOOLEAN         | 布尔类型   | 存储True或False                                              |
| DATE            | 日期类型   | 存储日期，如：2018-06-22                                     |
| TIME            | 时间类型   | 存储时间。如：12：20：59                                     |
| DATETIME        | 日期类型   | 存储日期+时间，例如：2018-06-22 12：20：59                   |

BIGINT能满足整数存储的需求，VARCHAR能满足字符串存储的需求。

SQL语言关键字不区分大小写，SQL一般约定关键字总是大写，以示突出，表名和列名均使用小写。

***

## 二、关系模型

关系型数据库是建立在关系模型上的，而关系模型本质上是若干个存储数据的二维表，可以把它看成很多EXCEL表。

* 表的每一行称为记录（Record），记录是一个逻辑意义上的数据。
* 表的每一列称为字段（Column），同一个表的每一行记录都拥有相同的若干字段。字段定义了数据类型，以及是否允许为NULL。NUll表示字段数据不存在。一个整型字段如果为NULL不表示它的值为0，同理，一个字符串型字段为NULL也不表示它的值为空串''。通常情况下，字段应避免允许为NULL，不允许为NULL可以简化查询，也利于应用程序读取数据后无需判断是否为NULL。

和EXCEL表不同的是，关系数据库的表与表之间需要建立“一对多”，“多对一”和“一对一”的关系。在关系型数据库中，关系是通过主键和外键来维护的。

***

### （一）主键

* 每一条记录都包含若干定义好的字段，同一个表的所有记录都有相同的字段定义。

* 对于关系表，有个很重要的约束，就是任意两条记录不能重复，不能重复不是指两条记录不完全相同，而是指能够通过某个字段唯一区分出不同的记录，这个字段被称为主键。
* 对于主键的要求：记录一旦插入到表中，主键最好不要再修改，因为主键是用来唯一定位的记录，修改了主键，会造成一系列的影响。所以，选取主键的一个基本原则是：不使用任何业务相关的字段作为主键。因此，身份证号码、手机号码和邮箱地址这些看上去可以唯一的字段，均不可以用作主键。主键最好是与业务完全无关的字段，一般这个字段名称为ID，ID字段类型有：
  * 自增整数类型。数据库会在插入数据时自动为每一条记录分配一个自增整数，这样我们就完全不用担心主键重复，也不用自己预先生成主键；字段定义：BIGINT NOT NULL AUTO_INCREMENT。
  * 全局唯一GUID类型。通过MAC地址，时间戳和随机数保证任意计算机在任意时间生成的字符串都是不同的。

***

### （二）联合主键

* 关系型数据库实际上允许通过多个字段唯一标识记录，即两个或更多的字段都设置为主键，这种主键被称为联合主键。对于联合主键，允许一列有重复，只要不是所有的主键列都重复即可，一般不建议使用联合主键。

小结：主键是关系表中记录的唯一标识，主键的选取非常重要，主键不要带有业务含义，而应该使用BIGINT自增或都 GUID类型。主键也不允许为NULL。可以使用多个列作为联合主键，但联合主键并不常用。

***

### （三）外键

* 通过某个字段把数据与另一张表关联起来，这种列称为外键。外键并不是通过列名实现的，而是通过定义外键约束实现的：

  ```sql
  ALTER TABLE students,
  ADD CONSTRAINT fk_class_id,
  FOREIGN KEY(class_id),
  REFERENCES class(id),
  ```

  其中，外键约束的名称fk_class_id可以任意，FOREIGN KEY（class_id）指定了class_id作为外键，REFERENCES class(id)指定了这个外键将关联到classes表的id列（即classes表的外键）。

* 删除外键的方法。

  ```sql
  ALTER TABLE students
  DROP FOREIGN fk_class_id;
  --删除外键约束并没有删除外键这一列，删除列通过DROP COLUMN...实现。
  ```

***

### （四）多对多

* 通过一个表的外键关联到另一个表，可以定义出一对多关系，有时还需多对多关系。如一个老师可以对应多个班级，一个班级也可以对应多个老师，因此，班级表和老师表存在多对多的关系，多对多关系实际上是通过两个一对多关系实现的，即通过一个中间表，关联两个一对多关系，就形成了多对多关系。e.g:
* teachers_tbl

| id   | name   |
| ---- | ------ |
| 1    | 娄老师 |
| 2    | 陆老师 |
| 3    | 马老师 |

* classes_tbl

| id   | name |
| ---- | ---- |
| 1    | 一班 |
| 2    | 二班 |

* 中间表teacher_class关联两个一对多关系

| id   | teacher_id | class_id |
| ---- | ---------- | -------- |
| 1    | 1          | 1        |
| 2    | 1          | 2        |
| 3    | 2          | 1        |
| 4    | 2          | 2        |
| 5    | 3          | 1        |
| 6    | 4          | 2        |

通过中间teacher_class可知teachers到classes的关系，通过中间表，我们定义了一个多对多的关系。

***

### （五）一对一

* 一对一关系是指一个表的记录对应到另一个表的唯一一个记录。如：students表的每个学生可以有自己的联系方式，如果把联系方式存入另一个表contacts，我们就可以得到一个"一对一"关系。如果业务允许，完全可以把两个表合为一个表，但是，有时候，如果某个学生没有手机号码，那么，contacts表就不存在对应的记录，实际上，一对一关系准确说，是contacts表一对一对应students表。

小结：关系数据库通过外键可以实现一对多、多对多和一对一的关系，外键可以通过数据库来约束，也可以不设置约束，仅靠应用程序的逻辑来保证。

***

### （六）索引

* 索引是关系数据库中的表对某一列或多个列的值进行预排序的数据结构。通过使用索引，可以让数据库系统不必扫描整个表，而是直接定位到符合条件的记录，这样就大大加快了查询速度。e.g:

```sql
ALTER TABLE students
ADD INDEX idx_name_score(score);
```

上述使用ADD INDEX idx_score(score)就创建了名称为idx_score，使用score的索引。索引名是任意的，索引如果有多列，可以在括号里依次写上。e.g:

```Sql
ALTER TABLE students
ADD INDEX idx_name_score(name, score);
```

索引的效率取决于索引列的值是否散列，即该列的值如果越互不相同，那么索引效率越高，反过来，如果记录的列存在大量的相同的值，如性别各占一半，因此，对该列创建索引就没有意义。

可以对一张表创建多个索引，索引的优点是提高了查询效率，缺点是在插入、更新和删除记录时，需要同时修改索引，因此，索引越多，插入、更新和删除记录的速度就越慢。

对于主键，关系数据库会自动对其创建主键索引，使用主键索引的效率是最高的，因为主键会保证绝对唯一。

***

### （七）唯一索引

在关系表中，看上去唯一的列，因含有业务逻辑，因此不宜作为主键。

但是这些列根据业务要求，以又具有唯一性约束，即不能出现两条记录存储了同一个身份证号码，这个时候就可以给该列添加一个唯一索引。方法如下：

```sql
ALTER TABLE students
ADD UNIQUE INDEX uni_name(ID_card)
```

通过UNIQUE关键字我们就添加了一个唯一索引。也可以只对某一列添加一个唯一约束而不是创建唯一索引。方法如下：

```sql
ALTER TABLE students
ADD CONSTRAINT uni_name UNIQUE(ID_CARD);
```

这种情况下，ID_card列没有索引，但仍然具有唯一性保证。

小结：

* 通过对数据库表创建索引，可以提高查询速度
* 通过创建唯一索引，可以保证某一列的值具有唯一性
* 数据库索引对于用户和应用程序来说都是透明的

***

## 三、查询数据

* 查看表结构。

  ```sql
  --通过SHOW关键字查看表的结构（字段名称）
  SHOW COLUMNS FROM table_name;
  --修改表的字段
  ALTER TABLE table_name CHANGE '旧字段名' '新字段名' '新数据类型';
  ```

* 基本查询。SELECT查询的结果是一个二维表。

  ```sql
  --SQL语法
  SELECT COLUMNS_NAME FROM table_name;
  SELECT * FROM table_name; --*表示选择所有的列
  --SELECT语句不定要求有FROM子句，e.g:
  SELECT 100 + 200;
  --不带FROM子句有一个有用的用途，就是用来判断当前到数据库的连接是否有效。许多检测工具会执行一条SELECT 1；来测试数据库连接。
  ```

* 条件查询。

  * 条件可以包含：<条件>AND<条件>、OR和NOT(等价于<>)，三者的优先级 NOT > AND > OR

  ```sql
  --语法
  SELECT * FROM <表名> WHERE <条件表达>
  ```

  * 常用的条件表达式。

    | 条件 | 表达式1          | 表达式2          | 说明                     |
    | ---- | ---------------- | ---------------- | ------------------------ |
    | =    |                  | name = 'abc'     | 字符串需要用单引号括起来 |
    | >    |                  |                  |                          |
    | >=   |                  |                  |                          |
    | <    |                  |                  |                          |
    | <=   |                  |                  |                          |
    | <>   |                  |                  |                          |
    | LIKE | name LIKE 'abc%' | name LIKE '%bc%' | %表示任意字符            |

* 投影查询。投影查询是让结果集只包含指定列。结果集的列名可以与原列名不同，可以自定义列名，

  ```sql
  --语法
  SELECT COLUMN1, ... FROM table_name;
  --别名
  SELECT COLUMN1 别名1,...FROM table_name;
  --WHERE条件查询
  SELECT id, score points, name FROM table_name WHERE gender = '男';
  ```

* 排序。默认查询的结果集通常按id排序，可以加上ORDER BY 子句按所指定的列进行升降序排序。如果有WHERE子句，那么ORDER BY 子句要放到WHERE子句的后面。

  ```sql
  --默认按升序ASC，DESC倒序
  SELECT id, name, score FROM table_name ORDER BY score DESC;
  --如果排序列有相同的数据，需进一步排序的可以继续添加列名
  SELECT id, name, gender, score FROM table_name ORDER BY score DESC, gender;
  --WHERE 子句
  SELECT id, name, gender, score FROM table_name WHERE class_id = 1 ORDER BY score DESC;
  ```

* 分页查询。如果数据量过大可以采用分页查询的方式进行。分页实际上是从结果集中截取出第M~N条记录，可以通过LIMIT <M>  OFFSET <N> 子句实现。

  ```sql
  SELECT id, name, gender, score FROM students ORDER BY score DESC;
  --每页显示3条记录，要获取第1页的记录，可以使用LIMIT 3 OFFSET 0
  SELECT id, name, gender, score FROM students ORDER BY score DESC LIMIT 3 OFFSET 0;
  --表示对结果集从0记录开始，最多取3条。注意SQL记录集的索引从0开始
  --如果要查询第2页，那么我们只需要跳过3条记录，也就是对结果集从3号记录开始查询，把OFFSET 设定为3
  SELECT id, name, gender, score FROM students ORDER BY score DESC LIMIT 3 OFFSET 3;
  ```

* 聚合查询。使用聚合函数查询就是聚合查询。如使用COUNT(*)查询所有列的行数，要注意聚合的计算结果虽然是一个数字，但查询结果仍然是一个二维表，只是这个二维表只有一行一列，并且列名是COUNT(*)，使用聚合查询的时候我们应给列名设置一个别名，便 于处理结果。COUNT（*）和COUNT(id)实际上一样的效果，聚合查询同样可以使用WHERE条件。如：

  ```sql
  SELECT COUNT(*) bodys FROM students WHERE gender='M'; 
  ```

  常用聚合函数：

  | 函数名 | 说明                                   |
  | ------ | -------------------------------------- |
  | SUM    | 计算某一列的合计值，该列必须为数值类型 |
  | AVG    | 计算某一列的平均值，该列必须为数值类型 |
  | MAX    | 计算某一列的最大值                     |
  | MIN    | 计算某一列的最小值                     |

  注意：MAX()和MIN()函数并不限于数值类型，如果是字符类型，两者分别返回排序最后和排序最前的字符。如果聚合查询的WHERE条件没有匹配到任何行，COUNT()会返回0，而SUM()、AVG()、MAX()和MIN()会返回NULL。
  
* 多表查询。使用SELECT * FROM <table1><table2>,这种方式一次查询两个表的数据，查询结果也是一个二维表，是两个表的乘积，两个表的第一行都两两拼在一起返返回，结果集的列数是table1和table2表的列数之和，行数是两个表的行数之积。可以利用投影查询的设置别名来给两个表稳中有降自的id和name列起别名。e.g:

  ```sh
  SELECT
      students.id sid,
      students.name,
      students.gender,
      students.score,
      classes.id cid,
      classes.name cname
   FROM students, classes;
  
  ```

  多表查询时，要使用表名.列名这样的方式来引用列和设置别名，这样可以避免结果集的列名重复问题。上述查询方式还可以使用下面的方法：

  ```sh
  -- set where clause:
  SELECT 
     s.id sid,
     s.name,
     s.gender,
     s.score,
     s.id cid,
     c.name cname
    FROM students s, classes c
    	WHERE s.gender = 'M' AND c.id = 1;
  ```

* 连接查询。先确定一个主表作为结果集，然后把其他表的行有选择性地连接在主表结果集上。操作方法如下：

  * 先确定主表，仍然使用FROM table1的语法;

  * 再确定需要连接的表，使用INSERT JOING  table2的语法

  * 然后确定连接条件，使用ON<条件...>，这里的条件是s.class_id=c.id，表示students表的class_id列与classes表的id列相同的行需要连接，

  * 可选。加上WHERE子句和ORDER BY等子句。

    ```
    SELECT s.id, s.name, s.class_id, c.name, class_name, s.gender, s.score
    FROM students s
    RIGHT OUTER JOIN classes c
    ON s.class_id = c.id;
    ```


***

## 四、修改数据

关系型数据库的基本操作是围绕增、删、改、查进行，即CRUD：Create、Retrieve、Update、Delete。其中查询使用select，而对于增、删、改对应的SQL语句如下：

* INSERT：插入新记录。可以一次向一个表中插入一条或多条记录。

  ```sql
  -- 语法格式
  INSERT INTO <表名> （字段名1,字段名2,...） VALUES (值1, 值2, ...);
  -- 表中的主键是自增字段，数据库可以自行推算，可以不用列出该字段。此外，如果一个字段有默认值，那么在INSERT语句中也可以不出现。字段顺序不必和数据表的字段顺序一致，但值的顺序必须和字段顺序一致。
  -- 一次性添加多条记录
  INSERT INTO students (class_id, name, gender, score) VALUES 
       (1, '大宝', 'M', 86),
       (2, '大牛', 'M', 89);
  ```

  

  * UPDATE： 更新已有记录。UPDATE语句的WHERE条件和SELECT语句的WHERE条件其实是一样的，因此可以一次更新多条记录。如果WHERE条件没有匹配到任何记录，UPDATE语句不会报错，也不会有任何记录被更新。UPDATE语句可以没有WHERE条件，如果不加条件整个表的所有记录都会被更新，所以，在执行UPDATE语句时要小心，最好先用SELECT语句来测试WHERE条件是否筛选出了期望的记录集，然后再用UPDATE更新。

  ```sql
  -- 语法格式
  UPDATE <表名> SET	字段1=值1, 字段2=値2,... WHERE ...; 
  ```

  

* DELETE： 删除已有记录。delete语句的WHERE条件也是用来筛选需要删除的行，因此和更新月类似，也可以一次性删除多条记录。如果没有匹配到任何记录，delete语句不会报错，也不会有任何记录被删除。会返回被删除的行数以及WHERE条件匹配的行数。

  ```sql
  --语法格式
  DELETE FROM <表名> WHERE ...;
  ```

## 五、Mysql管理

* 登陆。mysql -h 10.0.1.99 -u root -p

## 六、管理数据库

* 创建数据库。CREATE DATABASE 数据库名。
* 删除数据库。DROP DATABASE 数据库名。
* 选择数据库。USE 数据库名。
* 退出Mysql。EXIT。
* 查看当前数据库的所有表。SHOW TABLES;
* 查看表结构。DESC 表名。
* 查看创建表的SQL语句。SHOW CREATE TABLE 表名；
* 删除数据表。DROP TABLE 表名。
* 修改表。
  * 新增一列。ALTER TABLE 表名 ADD COLUMN 列名 字段类型 NOT NULL（是否为空）;
  * 修改一列。 ALTER TABLE 表名 CHANGE COLUMN 列名 原有字段 新字段 字段类型（大小） NOT NULL（是否为空）;
  * 删除一列。ALTER TABLE 表名 DROP COLUMN 列名

## 七、实用SQL语句。

* 插入或替换。如需要插入一条新记录，如果记录已存在，就须先删除原记录，再插入新记录，此时可以使用REPLACE语句。这样可以不必先查询决定是否删除再插入。语法格式：

  ```sql
   REPLACE INTO 表名(字段名,....) VALUES(对应字段值...); 
  ```

  若id记录不存在，REPLACE语句将插入新记录，否则，当前的id将被删除，然后再插入新记录。

* 插入或更新。可以使用INSERT INTO ... ON DUPLICATE KEY UPDATE ...

  ```sql
  INSERT INTO students (id, class_id, name, gender, score) VALUES (1, 1, '小明', 'F', 99) ON DUPLICATE KEY UPDATE name= '小明', gender='F', score=99;
  ```

* 插入或忽略。可以使用INSERT IGNORE INTO ...语句。

  ```sql
  INSERT IGNORE INTO students (id, class_id, name, gender, score) VALUES (1, 1, '小明', 'F', 99);
  ```

* 快照。如果想要对一个表进行快照，即复制一份当前表的数据到一个新表，可以结合 CREATE TABLE 和 SELECT。

  ```sql
  CREATE TABLE students_of_class1 SELECT * FROM students WHERE class_id=1;
  --新创建的表结构和SELECT使用的表结构完全一致。
  ```

* 写入查询结果集。如果查询结果需要写入到表中，可以结合INSERT和SELECT，将SELECT语句的结果集直接插入到指定表中。

  ```sql
  CREATE TABLE statistics (
     id BIGINT NOT NULL AUTO_INCREMENT,
      class_id BIGINT NOT NULL,
      average DOUBLE NOT NULL,
      PRIMARY KEY(ID)
  );
  --可以用一条语句写入各班的平均成绩
  INSERT INTO statistics (class_id, average) SELECT class_id, AVG(score) FROM students GROUP BY class_id;
  --确保INSERT语句的列和SELECT语句的列能一一对应，就可以在statistics表中保存查询的结果。
  ```

* 强制使用指定索引。在查询的时候，数据库系统会自动分析查询的语句，并选择一个最合适的索引。但是很多时候，数据库系统的查询并不一定总是能使用最优索引。如果需要可以使用FORCE INDEX强制查询使用指定的索引。语法如下：

  ```sql
  SELECT * FROM students FORCE INDEX(idx_class_id) WHERE class_id =1 ORDER BY id DESC;
  --指定索引的前提是索引必须存在。
  ```

## 八、总结

* 主键：唯一标识一行的列

* 外键：标示表与表相对关系的键（一对一，一对多，多对一，多对多）

* 索引：为了加快查询速度（插入等更改操作会变慢），为列预排序而建立的列

* 事务：多条语句变为原子操作

* 隔离级别：

  * [Read Uncommitted](https://www.liaoxuefeng.com/wiki/1177760294764384/1219071817284064)

  * [Read Committed](https://www.liaoxuefeng.com/wiki/1177760294764384/1245266514539200)

  * [Repeatable Read](https://www.liaoxuefeng.com/wiki/1177760294764384/1245268672511968)

  * [Serializable](https://www.liaoxuefeng.com/wiki/1177760294764384/1245268341158240)

* 脏读：未提交的更改导致另外一个事务提交前后查询的数据不一致

* 不可重复读：事务提交后，另一个事务在这个事务开始前与事务提交完查询后的数据不一致

* 幻读：一个事务插入操作，另外一个事务可以更改，并且查询出该行

  | Isolation Level  | 脏读（Dirty Read） | 不可重复读（Non Repeatable Read） | 幻读（Phantom Read） |
  | :--------------: | :----------------: | :-------------------------------: | :------------------: |
  | Read Uncommitted |        Yes         |                Yes                |         Yes          |
  |  Read Committed  |         -          |                Yes                |         Yes          |
  | Repeatable Read  |         -          |                 -                 |         Yes          |
  |   Serializable   |         -          |                 -                 |          -           |

```sql
--基本查询
SELECT * | 列1 <别名>，列二 , ..... FROM 表名 <别名>，表二 别名>，....      --查询哪一个表内的什么列
WHERE 条件表达式                                   --条件  
ORDER BY 列名 <ARC | DESC>;                        --排序

--聚集函数
--根据某列分组计算聚集函数，然后显示
SELECT AVG(列名) <别名> | SUM(列名) | .... FROM 表名
GROUP BY  列名 

--Crud
--插入一个或者多个
INSERT INTO 表名(列 1， 列2，.....) VALUES(v1,v2,v3,.....) ,( v1 )   ;

--删除根据条件一个或者多个行
DELETE FROM <表名> WHERE ...;

--更改-哪个表，哪个字段，哪个值
UPDATE <表名> SET 字段1=值1, 字段2=值2, ... WHERE ...;

--事务
BEGIN
....   --语句一
....   --语句二
COMMIT;

--回滚 -事务失败回滚(不是逻辑错误，逻辑错误能够运行成功)
BEGIN
...
....
...
ROLLBACK;


--还有设置索引，事务 创建更改表结构等
```

## 九、参考

* [设计实例 ](https://zhangjia.io/852.html)

* [E-R实体联系图设计](https://blog.csdn.net/q547550831/article/details/47186693)

 [20150801171314829](../../../ygy/20150801171314829) 

***

## 十、MYSQL学习笔记

### (一)常用命令

* 显示当前服务器版本。SELECT VERSION();
* 显示当前日期时间。SELECT NOW();
* 显示当前用户。SELECT USER();
* 查看警告信息。SHOW WARNINGS;

### (二)书写规范

* 关键字与函数名称全部大写。
* 数据库名称、表名称、字段名全部小写。
* SQL语句必须以分号结尾。

### (三)编码信息

可以在创建数据库的时候指定相应的编码。

```sql
CREATE DATABASE 数据库名 CAHRSET SET 编码方式(一般使用utf8);
```

### (四)数据库增删

```
-- 数据库修改
ALTER {DATABASE | SCHEMA} [db_name]
[DEFAULT] CHARACTER SET [=] charset_name;
-- {}为必选，[]为可选。
-- e.g:
ALTER DATABASE test2 CHARACTER SET utf8;
-- 数据库删除
DROP {DATABASE} [IF EXISTS] db_name;
```

### (五)默认约束

* DEFAULT。

  * 默认约束

  * 当插入记录时，如果没有明确为字段赋值，则自动赋予默认值。

    ```mysql
    CREATE TABLE IF NOT EXISTS students(
    	`students_id` BIGINT UNSIGEND AUTO_INCREMENT,
        `students_name` VARCAHR(20) NOT NULL UNIQUE KEY,
        `students_gender` ENUM('1', '2', '3') DEFAULT '3',
        PRIMARY KEY(`students_id`))ENGINE = InnoDB DEFAULT CHARSET utf8;
        -- 如果插入一条记录，仅设置姓名，不设置性别，那么就取默认。
    ```

### （六）外键约束

结束保证数据的完整性和一致性，约束分为表级约束和列级约束。

* 约束类型。

  * 非空约束。NOT NULL。
  * 主键约束。PRIMARY KEY。
  * 唯一约束。UNIQUE KEY。
  * 默认约束。DEFAULT。
  * 外键约束。FOREIGN KEY。外键约束是为了保持数据一致性和完整性，实现一对一或一对多的关系。
    * 外键约束要求。
      * 父表和子表必须使用相同的存储引擎，而且禁止使用临时表。
      * 数据表的存储引擎只能为InnoDB。
      * 外键列和参照列必须具有相似的数据类型。其中数字的长度或是否有符合位必须相同，而字符的长度则可以不同。
      * 外键列和参照列必须创建索引。如果外键列不存在索引的话，MYSQL将自动创建索引。

  