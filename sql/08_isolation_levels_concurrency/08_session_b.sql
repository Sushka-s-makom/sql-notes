-- lesson 8: session b script
-- open this in sql editor #2

-- sanity (should differ from session a)
select txid_current();

-- =========================================================
-- experiment 1: non-repeatable read (read committed)
-- run only when session a is waiting after its first select
-- =========================================================
begin;
update iso_accounts
set balance_cents = balance_cents + 500
where owner_name = 'alice';
commit;

-- =========================================================
-- experiment 2: repeatable read (stable snapshot)
-- run only when session a is inside repeatable read tx after first select
-- =========================================================
begin;
update iso_accounts
set balance_cents = balance_cents + 700
where owner_name = 'alice';
commit;

-- =========================================================
-- experiment 3: phantom (count)
-- run only when session a is between its first and second count
-- =========================================================
begin;
insert into iso_events (account_id, amount_cents)
select id, 100
from iso_accounts
where owner_name = 'alice';
commit;

-- =========================================================
-- experiment 4: lost update (bad pattern)
-- run step b1 when session a has read balance=10000 but not committed update yet
-- =========================================================
begin;
select balance_cents
from iso_accounts
where owner_name = 'alice';

-- pause here until session a commits its "set balance = 9000"

-- step b2: write final value (bad)
update iso_accounts
set balance_cents = 8000
where owner_name = 'alice';
commit;

-- =========================================================
-- fix a: atomic update
-- run after session a did atomic -1000 and committed
-- =========================================================
begin;
update iso_accounts
set balance_cents = balance_cents - 2000
where owner_name = 'alice';
commit;

-- =========================================================
-- fix b: select ... for update (read-then-decide)
-- run while session a holds for update (we will block until it commits)
-- =========================================================
begin;
select balance_cents
from iso_accounts
where owner_name = 'alice'
for update;

update iso_accounts
set balance_cents = balance_cents - 2000
where owner_name = 'alice';
commit;

select balance_cents
from iso_accounts
where owner_name = 'alice';
