# Домашнее задание к занятию «Работа с данными (DDL/DML)» Юлия Ш. SYS-19
$~$
>Задание можно выполнить как в любом IDE, так и в командной строке.
>
>### Задание 1
>1.1. Поднимите чистый инстанс MySQL версии 8.0+. Можно использовать локальный сервер или контейнер Docker.
>
>1.2. Создайте учётную запись sys_temp. 
>
>1.3. Выполните запрос на получение списка пользователей в базе данных. (скриншот)
>
>1.4. Дайте все права для пользователя sys_temp. 
>
>1.5. Выполните запрос на получение списка прав для пользователя sys_temp. (скриншот)
>
>1.6. Переподключитесь к базе данных от имени sys_temp.
>
>Для смены типа аутентификации с sha2 используйте запрос: 
>```sql
>ALTER USER 'sys_test'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
>```
>1.6. По ссылке https://downloads.mysql.com/docs/sakila-db.zip скачайте дамп базы данных.
>
>1.7. Восстановите дамп в базу данных.
>
>1.8. При работе в IDE сформируйте ER-диаграмму получившейся базы данных. При работе в командной строке используйте команду для получения всех таблиц базы данных. (скриншот)
>
>*Результатом работы должны быть скриншоты обозначенных заданий, а также простыня со всеми запросами.*
>
### Ответ к заданию 1  
* Установка MySQL при помощи официального репозитория *apt*:
![](img/sdbsql-2.1.1.png)
![](img/sdbsql-2.1.2.png)
![](img/sdbsql-2.1.3.png)
![](img/sdbsql-2.1.4.png)
![](img/sdbsql-2.1.5.png)
![](img/sdbsql-2.1.6.png)
![](img/sdbsql-2.1.7.png)
![](img/sdbsql-2.1.8.png)
![](img/sdbsql-2.1.9.png)
![](img/sdbsql-2.1.10.png)
* Проверка статуса и версии СУБД:
![](img/sdbsql-2.1.11.png)
* Запуск MySQL от имени пользователя *root*:
```
mysql -u root -p
```
![](img/sdbsql-2.1.12.png)
* Создание учетной записи *sys_temp*:
```sql
CREATE USER 'sys_temp'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY 'psswd';
```
![](img/sdbsql-2.1.13.png)
* Выполнение запроса на получение списка пользователей в базе данных:
```sql
SELECT user, host FROM mysql.user;
```
![](img/sdbsql-2.1.14.png)
* Выдача всех прав для пользователя *sys_temp*:
```sql
GRANT ALL PRIVILEGES ON *.* TO 'sys_temp'@'localhost' WITH GRANT OPTION;
```
![](img/sdbsql-2.1.15.png)
* Выполнение запроса на получение списка прав для пользователя *sys_temp*:
```sql
SHOW GRANTS FOR 'sys_temp'@'localhost';
```
![](img/sdbsql-2.1.16.png)
* Переподключение к базе данных от имени *sys_temp*, смена типа аутентификации и создание пустой БД *sakila*:
```
exit
```
```
mysql -u sys_temp -p
```
```sql
ALTER USER 'sys_temp'@'localhost' IDENTIFIED WITH mysql_native_password BY 'psswd';
```
```sql
CREATE DATABASE sakila;
```
![](img/sdbsql-2.1.17.png)
* Загрузка и распаковка архива с дампом БД *sakila*:
![](img/sdbsql-2.1.18.png)
* Восстановление дампа в БД:
```
mysql -u sys_temp -p sakila < ./sakila-db/sakila-schema.sql
```
```
mysql -u sys_temp -p sakila < ./sakila-db/sakila-data.sql
```
![](img/sdbsql-2.1.19.png)
* Использование команды для получения всех таблиц базы данных при работе в командной строке:
```sql
USE sakila;
```
```sql
SHOW TABLES;
```
![](img/sdbsql-2.1.20.png)
* Установка IDE *DBeaver* из официального deb-пакета:
![](img/sdbsql-2.1.21.png)
* ER-диаграмма получившейся базы данных, сформированная при работе в IDE *DBeaver*: 
![](img/sdbsql-2.1.22.png)
---
>
>### Задание 2
>Составьте таблицу, используя любой текстовый редактор или Excel, в которой должно быть два столбца: в первом должны быть названия таблиц восстановленной базы, во втором названия первичных ключей этих таблиц. Пример: (скриншот/текст)
>```
>Название таблицы | Название первичного ключа
>customer         | customer_id
>```
### Ответ к заданию 2  
* Формирование таблицы с помощью запроса к БД из командной строки:
```sql
SHOW DATABASES;
```
```sql
USE sakila;
```
```sql
SELECT TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'sakila' AND COLUMN_KEY = 'PRI' ORDER BY table_name;
```
![](img/sdbsql-2.2.1.png)
* Формирование таблицы с помощью запроса к БД в IDE *DBeaver*:
![](img/sdbsql-2.2.2.png)
---
>
>## Дополнительные задания (со звёздочкой*)
>Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.
>
>
>### Задание 3*
>3.1. Уберите у пользователя sys_temp права на внесение, изменение и удаление данных из базы sakila.
>
>3.2. Выполните запрос на получение списка прав для пользователя sys_temp. (скриншот)
>
>*Результатом работы должны быть скриншоты обозначенных заданий, а также простыня со всеми запросами.*
>
### Ответ к заданию 3*  
* При полных правах, выданных на все БД, в СУБД нельзя отозвать определенные права на определенную БД.
* Выполнен отзыв всех прав на все БД:
```sql
REVOKE ALL PRIVILEGES ON *.* FROM 'sys_temp'@'localhost';
```
* Выданы полные права на БД *sakila*:
```sql
GRANT ALL PRIVILEGES ON sakila.* TO 'sys_temp'@'localhost' WITH GRANT OPTION;
```
* Выполнен отзыв определенных прав на БД *sakila*:
```sql
REVOKE ALTER, CREATE, DELETE, DROP, INSERT, UPDATE ON sakila.* FROM 'sys_temp'@'localhost';
```
* Выполнен запрос на получение списка прав для пользователя *sys_temp*:
```sql
SHOW GRANTS FOR 'sys_temp'@'localhost';
```
![](img/sdbsql-2.3.1.png)
