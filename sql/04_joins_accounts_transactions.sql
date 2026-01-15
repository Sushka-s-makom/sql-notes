-- 04: joins (accounts + transactions)

drop table if exists transactions;
drop table if exists accounts;

create table accounts (
  id bigserial primary key,
  owner_name text not null,
  currency char(3) not null,
  balance_cents bigint not null default 0
);

create table transactions (
  id bigserial primary key,
  account_id bigint not null references accounts(id),
  amount_cents bigint not null,
  description text,
  created_at timestamptz not null default now()
);

insert into accounts (owner_name, currency, balance_cents) values
  ('Alice', 'USD', 150000),
  ('Bob',   'USD',  20000),
  ('Ivan',  'RUB', 990000);

insert into transactions (account_id, amount_cents, description) values
  (1, -2500,  'coffee'),
  (1,  5000,  'refund'),
  (2, -1000,  'taxi'),
  (3, -45000, 'groceries');

-- inner join: операции + владелец
select
  t.id,
  a.owner_name,
  a.currency,
  t.amount_cents,
  t.description,
  t.created_at
from transaction as t
join accounts as a on a.id = t.account_id
order by t.id;

-- аккаунт без операций
insert into accounts (owner_name, currency, balance_cents)
values ('NoTx', 'USD', 0);

-- left join + group by: число операций на аккаунт
select
  a.id,
  a.owner_name,
  count(t.id) as tx_count
from accounts as a
left join transactions as t on t.account_id = a.id
group by a.id, a.owner_name
order by a.id;

-- left join без группировки: показать строки-операции (или null)
select
  a.id as account_id,
  a.owner_name,
  t.id as tx_id,
  t.amount_cents,
  t.description
from accounts a
left join transactions t on t.account_id = a.id
order by a.id, t.id;
