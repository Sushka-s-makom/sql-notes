-- lesson 8 setup: tables + seed data

drop table if exists iso_events;
drop table if exists iso_accounts;

create table iso_accounts (
  id bigserial primary key,
  owner_name text not null,
  balance_cents bigint not null check (balance_cents >= 0)
);

insert into iso_accounts (owner_name, balance_cents)
values
  ('alice', 10000),
  ('bob',   10000);

create table iso_events (
  id bigserial primary key,
  account_id bigint not null references iso_accounts(id),
  amount_cents bigint not null,
  created_at timestamptz not null default now()
);

-- seed one event for alice
insert into iso_events (account_id, amount_cents)
select id, 100
from iso_accounts
where owner_name = 'alice';

select * from iso_accounts order by id;

-- optional: verify current session id
select txid_current();
