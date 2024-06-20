# Домашнее задание к занятию «Индексы» Юлия Ш. SYS-19
$~$
> ### Задание 1
>
> Напишите запрос к учебной базе данных, который вернёт процентное отношение общего размера всех индексов к общему размеру всех таблиц.
>
### Ответ к заданию 1
```sql
SELECT SUM(index_length) / SUM(data_length) * 100 AS percent_ratio
FROM information_schema.tables
WHERE table_schema = 'sakila';
```
![](img/sdbsql-5.1.1.png)

---
> ### Задание 2
> 
> Выполните explain analyze следующего запроса:
> ```sql
> select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
> from payment p, rental r, customer c, inventory i, film f
> where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id
> ```
> - перечислите узкие места;
> - оптимизируйте запрос: внесите корректировки по использованию операторов, при необходимости добавьте индексы.
>
### Ответ к заданию 2
* Выполнение *EXPLAIN ANALYZE*  запроса из задания, а также самого запроса:
![](img/sdbsql-5.2.1.png)
![](img/sdbsql-5.2.2.png)
* Оптимизированный запрос, его *EXPLAIN ANALYZE* и запуск:
```sql
SELECT DISTINCT CONCAT(c.last_name, ' ', c.first_name), SUM(p.amount) OVER(PARTITION BY c.customer_id)
FROM payment p, customer c
WHERE DATE(p.payment_date) = '2005-07-30' AND p.customer_id = c.customer_id;
```
![](img/sdbsql-5.2.3.png)
![](img/sdbsql-5.2.4.png)
* Проверка существующих индексов для таблиц, задействованных в запросе:
```sql
SHOW indexes FROM payment;
```
```sql
SHOW indexes FROM customer;
```
![](img/sdbsql-5.2.5.png)
* Создание индекса *idx_payment_date* для поля *payment_date* таблицы *payment*:
```sql
CREATE INDEX idx_payment_date ON payment(payment_date);
```
![](img/sdbsql-5.2.6.png)
* Проверка использования созданного индекса при выполнении запроса с помощью *EXPLAIN*. Индекс остался не задействован:
![](img/sdbsql-5.2.7.png)
* Скорректированный запрос, его выполнение, проверка использования индекса помощью *EXPLAIN* и выполнение *EXPLAIN ANALYZE*:
```sql
SELECT DISTINCT CONCAT(c.last_name, ' ', c.first_name), SUM(p.amount) OVER(PARTITION BY c.customer_id)
FROM payment p USE INDEX (idx_payment_date), customer c 
WHERE payment_date >= '2005-07-30' and payment_date < '2005-07-31' AND p.customer_id = c.customer_id;
```
![](img/sdbsql-5.2.8.png)
![](img/sdbsql-5.2.9.png)
---
> ## Дополнительные задания (со звёздочкой*)
> Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.
> 
> ### Задание 3*
> 
> Самостоятельно изучите, какие типы индексов используются в PostgreSQL. Перечислите те индексы, которые используются в PostgreSQL, а в MySQL — нет.
> 
> *Приведите ответ в свободной форме.*
>
### Ответ к заданию 3*
* Сводная таблица типов индексов, представленная в статье https://habr.com/ru/articles/102785/ :
![](img/sdbsql-5.3.1.png)
* Типы индексов, используемые в PostgreSQL и отсутствующие в MySQL:
	- Bitmap index;
	- Partial index;
	- Function based index.

