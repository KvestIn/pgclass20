
PostgreSQL и btrfs — слон на маслянной диете
https://habrahabr.ru/post/261921/

RAM диск 
StarWind RAM Disk https://www.starwindsoftware.com/high-performance-ram-disk-emulator

Создать диск размером 1024 мб и подключить его как диск E


Vanessa PG Steroids 2.0
=======================

>   у каждого разработчика 1С - должен стоять локально PostgreSQL, чтобы не
>   расслабляться

Репозиторий содержит комплект автоматизированных средств для персонального
изучения поведения платформы 1С и сервера управления базами данных PostgreSQL, а
также методическую информацию для начинающих и профессиональных экспертов по
производительности 1С

Данный репозиторий предполагает базовые знания по платформе 1С в части

-   [Вы ознакомились с настольной книгой 1С
    эксперта](http://v8.1c.ru/metod/books/book.jsp?id=452)

-   [Вы знаете что можно использовать сборку PostgreSQL от компании Postgres
    Professional](https://postgrespro.ru/products/1c)

-   **Вы на базовом уровне представляете, как работает GIT, Vagrant и Docker**

Начало работы
-------------

-   Убедитесь, что ваш компьютер поддерживает виртуализацию

-   Установите Vagrant

-   [Изучите документацию](docs/README.md)

-   Выполните действия по запуску описанные в документации

-   [Изучите FAQ](docs/FAQ.md)

-   Расширяйте документацию и скрипты – предлагайте свои изменения

-   Запускайте 1С на PostgreSQL в продуктиве

Порядок работы контрибьютора
----------------------------

Репозиторий открыт для разработки и документирования, расширять можно как
документацию, так и исходный код, единственной особенностью является то, что мы

Для доработки используйте концепцию GITHUB FLOW

-   Fork

-   Create Branch

-   Pull Request

Не забываете тестировать свои изменения если они затрагивают автоматизированные
средства при помощи Vagrant, Docker и инструментов разработчика

Лицензии
========

-   Текстовый и методический материал распространяется под лицензией **Community
    Creative Commons**

-   Средства автоматизации распространяются под лицензией **Mozilla Public
    License Version 2.0**

Подробней смотри в файле [lic/README.md](lic/README.md)

### Цели, авторы, благодарности

мы считаем, что разработчик 1С должен проверять свои решения под работой не
только MSSQL, но и PostgreSQL. Для быстроты запуска такого контура и создан этот
репозиторий.

#### Авторы

-   <https://github.com/allustin>

-   <https://github.com/pumbaEO>

-   <https://github.com/ebessonov>

#### Благодарности

-   <http://infostart.ru/>

-   <https://github.com/postgrespro/>

-   <https://github.com/PostgreSQL-Consulting>

-   <https://github.com/2ndQuadrant>

-   <http://dalibo.github.io/>

-   <https://pgday.ru>