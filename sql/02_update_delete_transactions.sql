-- 02: update, delete, where, transactions (begin/commit/rollback)

-- просмотр текущих данных
select * from users order by id;

-- update с where (без where обновятся все строки)
update users
set age = 26
where name = 'Bob';

select * from users order by id;

-- delete с where
delete from users
where name = 'Ivan';

select * from users order by id;

-- безопасный приём: сначала select, потом update/delete
select *
from users
where age is null;

-- транзакции: демонстрация отката
begin;

update users
set age = 99;

select * from users order by id;

rollback; 'отмена транзакции'

select * from users order by id;
