-- 03: агрегаты, group by, having

-- добавил данные
-- insert into users (name, age) values
--   ('Masha', 18),
--   ('Petr', 18),
--   ('Olga', 25),
--   ('Sergey', 30);

-- сколько всего пользователей
select count(*) as total_users
from users;

-- средний возраст (null не учитываются)
select avg(age) as avg_age
from users;

-- минимальный и максимальный возраст
select min(age) as min_age, max(age) as max_age
from users;

-- сколько пользователей каждого возраста
select age, count(*) as cnt
from users
group by age
order by age asc nulls last;

-- оставить только те возраста, где пользователей 2+(having для сортировки групп, where - для строк)
select age, count(*) as cnt
from users
group by age
having count(*) >= 2
order by age asc nulls last;

-- пример where + group by:
-- where фильтрует строки до группировки
select age, count(*) as cnt
from users
where age is not null and age >= 20
group by age
order by age;
