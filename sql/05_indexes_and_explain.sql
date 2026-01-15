-- 05: indexes and explain

-- типовой запрос микросервиса:
-- получить операции конкретного аккаунта
select *
from transactions
where account_id = 1
order by created_at desc
limit 20;

-- посмотреть, КАК postgres собирается выполнять запрос( через индекс или сек)
explain
select *
from transactions
where account_id = 1
order by created_at desc
limit 20;

-- индекс под типовой запрос:
-- сначала фильтрация по account_id,
-- затем сортировка по created_at
create index if not exists idx_tx_account_created_at
on transactions (account_id, created_at desc);

-- снова смотрим план
explain
select *
from transactions
where account_id = 1
order by created_at desc
limit 20;

-- explain не выполняет запрос,
-- а только показывает план выполнения
