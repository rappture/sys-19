# Домашнее задание к занятию «Репликация и масштабирование»
$~$
> ### Задание 1
> 
> На лекции рассматривались режимы репликации master-slave, master-master, опишите их различия.
> 
> *Ответить в свободной форме.*
> 
### Ответ к заданию 1
* В случае репликации в режиме master-slave данные с сервера-источника реплицируются на сервер-реплику (только в одном направлении).
* В случае репликации в режиме master-master оба сервера являются одновременно источником и репликой, т.е изменения в данных на одном источнике будут реплицированы на втором и наоборот.

---
> ### Задание 2
> 
> Выполните конфигурацию master-slave репликации, примером можно пользоваться из лекции.
> 
> *Приложите скриншоты конфигурации, выполнения работы: состояния и режимы работы серверов.*
> 
### Ответ к заданию 2
* Настройка виртуальной машины (ВМ), задействованной в предыдущих заданиях (имя хоста изменено на *first-deb11*), на использование в качестве *source (master)*:

```bash
# Редактирование конфигурационного файла
sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
```
Ссылка на конфигурационный файл MySQL для *first-deb11 (source)* --> [mysqld.cnf](conf/sdbsql-6/T2_VM1_SOURCE_mysqld.cnf).
```bash
# Перезапуск mysql-server
sudo systemctl restart mysql
```
```bash
# Проверка статуса mysql-server
sudo systemctl status mysql
```
![](img/sdbsql-6.2.1.png)
```bash
# Выполнение входа в mysql
mysql -u root -p
```
```mysql
# Создание пользователя для репликации
CREATE USER 'replica_user'@'%' IDENTIFIED WITH mysql_native_password BY 'REPpas';
```
```mysql
# Предоставление пользователю минимально необходимых привелегий
GRANT REPLICATION SLAVE ON *.* TO 'replica_user'@'%';
```
```mysql
# Обновление загруженных в память данных о привилегиях 
FLUSH PRIVILEGES;
```
```mysql
# Закрытие всех открытых таблиц и блокировка доступа для чтения всех таблиц для всех баз данных
FLUSH TABLES WITH READ LOCK;
```
```mysql
# Запуск команды, которая возвращает информацию о текущем состоянии бинарных файлов логов для source
SHOW MASTER STATUS;
```
![](img/sdbsql-6.2.2.png)

```bash
# Создание дамп-файла для базы данных (БД) sakila во втором окне терминала
sudo mysqldump -u root sakila > sakila.sql;
```
![](img/sdbsql-6.2.3.png)

```mysql
# Разблокировка баз данных в первоначальном окне терминала
UNLOCK TABLES;
```
![](img/sdbsql-6.2.4.png)
```bash
# Копирование дамп-файла БД sakila на ВМ при помощи SSH
scp ./sakila.sql yuliya_shkutova@10.0.3.7:/tmp/
# Если ключи не были настроены ранее, потребуется сгенерировать и передать ключ с помощью команд:
# ssh-keygen
# ssh-copy-id yuliya_shkutova@10.0.3.7
```
  
* Настройка чистой ВМ *second-deb11* на использование в качестве *replica (slave)*.
```bash
# Загрузка пакета для подключения репозитория с официального ресурса MySQL 
wget https://dev.mysql.com/get/mysql-apt-config_0.8.26-1_all.deb
```
```bash
# Установка загруженного пакета
sudo apt install ./mysql-apt-config_0.8.26-1_all.deb 
```
```bash
# Обновление списка пакетов
sudo apt update
```
```bash
# Установка mysql-server
sudo apt install mysql-server
# mysql-client устанавливается apt совместно с mysql-server в числе дополнительных пакетов
```
![](img/sdbsql-6.2.5.png)
```bash
# Подключение к MySQL
mysql -u root -p
```
```mysql
# Создание пустой БД sakila
CREATE DATABASE sakila;
# Выход из MySQL
exit
```
```bash
# Восстановление БД из дамп-файла, полученного с ВМ first-deb11
mysql -u root -p sakila < /tmp/sakila.sql
```
![](img/sdbsql-6.2.6.png)

```bash
# Редактирование конфигурационного файла
sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
```
Ссылка на конфигурационный файл MySQL *second-deb11 (replica)* --> [mysqld.cnf](conf/sdbsql-6/T2_VM2_REPLICA_mysqld.cnf).
```bash
# Перезапуск mysql-server
sudo systemctl restart mysql
```
```bash
# Подключение к MySQL
mysql -u root -p
```
```mysql
# Запуск команды с настройками репликации
CHANGE REPLICATION SOURCE TO
SOURCE_HOST='10.0.3.4',
SOURCE_USER='replica_user',
SOURCE_PASSWORD='REPpas',
SOURCE_LOG_FILE='mysql-bin.000001',
SOURCE_LOG_POS=843;
```
```mysql
# Запуск команды для активации репликации
START REPLICA;
```
![](img/sdbsql-6.2.7.png)
```mysql
# Запуск команды для вывода статуса репликации
SHOW REPLICA STATUS\G;
```
![](img/sdbsql-6.2.8.png)
* Тестирование результатов настройки *source-replica (master-slave)*:
  - На ВМ first-deb11 (source):
    ```mysql
    # Создание пустой тестовой БД
    CREATE DATABASE test001;
    ```
    ![](img/sdbsql-6.2.9.png)   
  - На ВМ second-deb11 (replica):
    ```mysql
    # Вывод списка БД
    SHOW DATABASES;
    ```
    ![](img/sdbsql-6.2.10.png)

  - На ВМ first-deb11 (source):
    ```mysql
    # Выбор БД sakila
    use sakila;
    ```
    ```mysql
    # Создание тестовой таблицы
    CREATE TABLE example_table (
    example_column varchar(30)
    );
    ```
    ```mysql
    # Внесение тестовых данных
    INSERT INTO example_table VALUES
    ('This is the first row'),
    ('This is the second row'),
    ('This is the third row');
    ``` 
    ![](img/sdbsql-6.2.11.png)   
  - На ВМ second-deb11 (replica):
    ```mysql
    # Выбор БД sakila
    use sakila;
    ```
    ```mysql
    # Вывод списка таблиц    
    SHOW TABLES;
    ```
    ```mysql
    # Вывод всей информации из тестовой таблицы   
    SELECT * FROM example_table;
    ```
    ![](img/sdbsql-6.2.12.png)   
---
> ## Дополнительные задания (со звёздочкой*)
> Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.
> 
> ---
> ### Задание 3* 
> 
> Выполните конфигурацию master-master репликации. Произведите проверку.
> 
> *Приложите скриншоты конфигурации, выполнения работы: состояния и режимы работы серверов.*
> 
### Ответ к заданию 3*
* Внесение изменений в конфигурационные файлы, перезапуск и проверка статуса MySQL на обеих ВМ:
  - Ссылка на конфигурационный файл MySQL *first-deb11 (source)* --> [mysqld.cnf](conf/sdbsql-6/T3_VM1_SOURCE_mysqld.cnf).
  - Ссылка на конфигурационный файл MySQL *second-deb11 (source)* --> [mysqld.cnf](conf/sdbsql-6/T3_VM2_SOURCE_mysqld.cnf).
  
  ![](img/sdbsql-6.3.1.png)
  
* Ввод конфигурационных команд MySQL на обеих ВМ:
  
  ![](img/sdbsql-6.3.2.png)
  
* Проверка статуса репликации на обеих ВМ:
  
  ![](img/sdbsql-6.3.3.png)
  
* Тестирование результатов настройки *source-source (master-master)*:
  1. Вывод списка БД на обеих ВМ
  2. Удаление БД test001 на *second-deb11*
  3. Вывод списка БД на *first-deb11*
  4. Создание БД test002 на *first-deb11*
  5. Вывод списка БД на *second-deb11*

  ![](img/sdbsql-6.3.4.png)
