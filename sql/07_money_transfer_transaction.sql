-- 07: money transfer (atomicity, locking, consistency)

-- constraint: баланс не должен быть отрицательным
alter table accounts
add constraint chk_accounts_balance_non_negative
check (balance_cents >= 0);

-- пример перевода: 1000 cents с account 1 на account 2
begin;

select id, balance_cents
from accounts
where id in (1, 2)
for update;

update accounts
set balance_cents = balance_cents - 1000
where id = 1;

update accounts
set balance_cents = balance_cents + 1000
where id = 2;

insert into transactions (account_id, amount_cents, description)
values
  (1, -1000, 'transfer to account 2'),
  (2,  1000, 'transfer from account 1');

commit;
