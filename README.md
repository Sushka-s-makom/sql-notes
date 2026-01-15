# sql-notes

Учебный репозиторий для изучения PostgreSQL
(сначала база бд, потом буду ориентироваться на микросервисы и финтех бдшки).

## Быстрый старт

```bash
docker compose up -d

## Подключение (DBeaver)

- host: localhost
- port: 15432
- db: appdb
- user: app
- password: app


## Пройденные темы
- основы sql: select / insert / update / delete
- транзакции: begin / commit / rollback
- агрегаты: group by / having
- joins: inner / left
- индексы и explain
