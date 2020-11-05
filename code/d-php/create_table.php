<?php
$dbhost = 'localhost'; //mysql服务器主机地址
$dbuser = 'root'; //mysql用户名
$dbpassword = ''; //mysql登陆密码
$conn = mysqli_connect($dbhost, $dbuser, $dbpassword);
if (!$conn) {
    die('连接错误' . mysqli_error($conn));
}
echo '数据库连接成功 <br>';
echo '<hr>';
$sql = 'CREATE DATABASE IF NOT EXISTS BLOG';