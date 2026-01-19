-- lesson 8: session a script
-- open this in sql editor #1

-- sanity (should differ from session b)
select txid_current();

-- =========================================================
-- experiment 1: non-repeatable read (read committed)
-- step a1
-- =========================================================
begin;
select balance_cents
from iso_accounts
where owner_name = 'alice';

-- pause here and run session b: experiment 1 (adds +500 and commits)

-- step a2 (same transaction, run after b commit)
select balance_cents
from iso_accounts
where owner_name = 'alice';
commit;

-- =========================================================
-- experiment 2: repeatable read (stable snapshot)
-- step a1
-- =========================================================
update iso_accounts
set balance_cents = 10000
where owner_name = 'alice';

begin isolation level repeatable read;
select balance_cents
from iso_accounts
where owner_name = 'alice';

-- pause here and run session b: experiment 2 (adds +700 and commits)

-- step a2 (still same transaction)
select balance_cents
from iso_accounts
where owner_name = 'alice';
commit;

-- after commit, new transaction sees new reality
begin;
select balance_cents
from iso_accounts
where owner_name = 'alice';
commit;

-- =========================================================
-- experiment 3: phantom (count)
-- step a1
-- =========================================================
begin;
select count(*) as cnt
from iso_events
where account_id = (select id from iso_accounts where owner_name = 'alice');

-- pause here and run session b: experiment 3 (inserts new iso_event and commits)

-- step a2 (same transaction)
select count(*) as cnt
from iso_events
where account_id = (select id from iso_accounts where owner_name = 'alice');
commit;

-- =========================================================
-- experiment 4: lost update (bad pattern)
-- step a1
-- =========================================================
update iso_accounts
set balance_cents = 10000
where owner_name = 'alice';

begin;
select balance_cents
from iso_accounts
where owner_name = 'alice';

-- pause: let session b also read balance=10000 (exp 4)

-- step a2: write final value (bad)
update iso_accounts
set balance_cents = 9000
where owner_name = 'alice';
commit;

-- pause: let session b now write its final value and commit (exp 4)

-- check final result
select balance_cents
from iso_accounts
where owner_name = 'alice';

-- =========================================================
-- fix a: atomic update (good for balances)
-- =========================================================
update iso_accounts
set balance_cents = 10000
where owner_name = 'alice';

begin;
update iso_accounts
set balance_cents = balance_cents - 1000
where owner_name = 'alice';
commit;

-- pause: let session b subtract -2000 with atomic update and commit (fix a)

select balance_cents
from iso_accounts
where owner_name = 'alice';

-- =========================================================
-- fix b: select ... for update (read-then-decide)
-- step a1
-- =========================================================
update iso_accounts
set balance_cents = 10000
where owner_name = 'alice';

begin;
select balance_cents
from iso_accounts
where owner_name = 'alice'
for update;

-- do checks here (e.g., balance >= 1000), then update
update iso_accounts
set balance_cents = balance_cents - 1000
where owner_name = 'alice';

-- pause: run session b fix b (it will wait on for update until we commit)

commit;

select balance_cents
from iso_accounts
where owner_name = 'alice';
