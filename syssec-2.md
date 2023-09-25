# Домашнее задание к занятию  «Защита хоста» Юлия Ш. SYS-19
$~$
> ### Задание 1
> 
> 1. Установите **eCryptfs**.
> 2. Добавьте пользователя cryptouser.
> 3. Зашифруйте домашний каталог пользователя с помощью eCryptfs.
> 
> *В качестве ответа  пришлите снимки экрана домашнего каталога пользователя с исходными и зашифрованными данными.*  
>
### Ответ к заданию 1
* Установка *eCryptfs*:
![](img/syssec-2.1.1.png)
* Опция ```--encrypt-home``` (создания пользователя с зашифрованным домашним каталогом) не доступна для утилиты ```adduser``` на Debian:
![](img/syssec-2.1.2.png)
* Создание пользователя *cryptouser*:
![](img/syssec-2.1.3.png)
* Шифрование домашнего каталога пользователя с помощью *eCryptfs*:
  - Первый запуск. Ошибка с требованием установить ```rsync```, установка данной программы:
  ![](img/syssec-2.1.4.png)
  - Второй запуск. Ошибка о не загруженном модуле *eCryptfs*. Решение с помощью перезагрузки:
  ![](img/syssec-2.1.5.png)
  - Третий запуск. Успешно:
  ![](img/syssec-2.1.6.png)
* Переключение на пользователя *cryptouser*, создание тестового файла, проверка доступности содержимого домашнего каталога, выход из учетной записи:
![](img/syssec-2.1.7.png)
* Проверка файлов во временной резервной копии ```/home/cryptouser.0AXSEUGj/``` и доступа к зашифрованному каталогу ```/home/cryptouser/``` из под другого пользователя:
![](img/syssec-2.1.8.png)
* Удаление временной резервной копии:
![](img/syssec-2.1.9.png)
* Переключение на пользователя *cryptouser*, выполнение команды вывода парольной фразы для доступа к зашифрованным данным:
![](img/syssec-2.1.10.png)
* Выполнение команды на шифрование *swap*:
  - Первый запуск. Ошибка с требованием установить ```cryptsetup```, установка данной программы из под пользователя с правами *sudo*:
  ![](img/syssec-2.1.11.png)
  - Второй запуск. Ошибка с требованием запуска команды от пользователя с правами  *sudo* или *root* (от пользователя *root* почему-то *swap*-раздел не обнаружен). Возвращение к учетной записи с правами *sudo*: 
  ![](img/syssec-2.1.12.png)
  - Третий запуск. Ошибка по запуску ```swapon```:
  ![](img/syssec-2.1.13.png)
  - Проверка состояния системы и конфигурационных файлов, выполнение перезапуска:
    ![](img/syssec-2.1.14.png)
  - Проверка состояния системы после перезагрузки. Зашифрованный *swap* активен:
  ![](img/syssec-2.1.15.png)
> ### Задание 2
> 
> 1. Установите поддержку **LUKS**.
> 2. Создайте небольшой раздел, например, 100 Мб.
> 3. Зашифруйте созданный раздел с помощью LUKS.
> 
> *В качестве ответа пришлите снимки экрана с поэтапным выполнением задания.*
>
### Ответ к заданию 2
* Поддержка *LUKS* была установлена в рамках выполнения задания 1. Проверка текущей версии ```cryptsetup```:
![](img/syssec-2.2.1.png)
* Вывод информации об устройствах хранения:
![](img/syssec-2.2.2.png)
* Выполнение разметки диска *sdb*:
![](img/syssec-2.2.3.png)
* Шифрование созданного раздела с помощью *LUKS*:
  - Подготовка раздела:
  ![](img/syssec-2.2.4.png)
  - Монтирование раздела:
  ![](img/syssec-2.2.5.png)
  - Форматирование раздела:
  ![](img/syssec-2.2.6.png)
  - Монтирование «открытого» раздела, проверка результата с помощью ```lsblk```:
  ![](img/syssec-2.2.7.png)
  - Проверка возможности работы с шифрованным диском, завершение работы:
  ![](img/syssec-2.2.8.png)
> ## Дополнительные задания (со звёздочкой*)
> 
> Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале
> 
> ### Задание 3 *
> 
> 1. Установите **apparmor**.
> 2. Повторите эксперимент, указанный в лекции.
> 3. Отключите (удалите) apparmor.
> 
> *В качестве ответа пришлите снимки экрана с поэтапным выполнением задания.*
> 
### Ответ к заданию 3 *
* Установка *AppArmor*:
![](img/syssec-2.3.1.png)
* Проверка статуса *AppArmor*. Программа ```/usr/bin/man``` уже включена в список *enforce mode*:
![](img/syssec-2.3.2.png)
* Вывод списка профилей *AppArmor*:
![](img/syssec-2.3.3.png)
* Выполнение подмены ```man``` на ```ping```, попытка запуска "вредоносного" ```man```:
![](img/syssec-2.3.4.png)
* Переключение работы с программой ```/usr/bin/man``` на режим ```aa-complain```, проверка сопутствующих записей системного журнала:
![](img/syssec-2.3.5.png)
* Повторный запуск ```man```, проверка сопутствующих записей в системном журнале:
![](img/syssec-2.3.6.png)
* Возвращение ```man``` в режим ```aa-enforce```, проверка результата:
![](img/syssec-2.3.7.png)
* Отключение (удаление) *AppArmor*:
  - Остановка сервиса:
  ![](img/syssec-2.3.8.png)
  - Выгрузка профилей:
  ![](img/syssec-2.3.9.png)
  - Удаление *AppArmor* и сопутствующих данных через ```apt```:
  ![](img/syssec-2.3.10.png)
  - Проверка результатов, выполнение перезагрузки:
  ![](img/syssec-2.3.11.png)
  - Проверка результатов после перезагрузки:
  ![](img/syssec-2.3.12.png)
  - Выполнение отключения на *AppArmor* уровне ядра в соответствии с [инструкцией](https://wiki.debian.org/AppArmor/HowToUse#Disable_AppArmor), размещенной на официальном сайте Debian, выполнение перезагрузки:
  ![](img/syssec-2.3.13.png)
  - Проверка результатов после перезагрузки. Вывод - штатными средствами полностью убрать все данные *AppArmor* не представляется возможным:
  ![](img/syssec-2.3.14.png)