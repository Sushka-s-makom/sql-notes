-- 01: users — создание таблицы и базовые запросы

create table users (
  id   serial primary key,
  name text not null,
  age  int
);

insert into users (name, age) values
  ('Alice', 20),
  ('Bob', 25),
  ('Ivan', null);

-- вывод всех строк
select * from users;

-- фильтрация через where
select id, name, age
from users
where age >= 21;

-- сортировка, null вверх
select id, name, age
from users
order by age desc nulls first;