-- 06: constraints (data integrity)
-- цель: понять как задаются ограничения целостности данных

-- not null (обычно задаётся в create table рядом с колонкой)
-- пример (как справка, не выполнять):
-- create table t (name text not null);

-- not null через alter table (другой синтаксис)
alter table accounts
alter column owner_name set not null;

alter table accounts
alter column currency set not null;

alter table transactions
alter column account_id set not null;

alter table transactions
alter column amount_cents set not null;

-- unique: один владелец не может иметь два счёта в одной валюте (упрощённое правило)
alter table accounts
add constraint uniq_accounts_owner_currency
unique (owner_name, currency);

-- check: операция не может быть нулевой
alter table transactions
add constraint chk_transactions_amount_not_zero
check (amount_cents <> 0);

-- foreign key уже задан при create table (как справка):
-- account_id bigint not null references accounts(id);
