# урок 8 — уровни изоляции и конкуренция (postgresql)

## цель
Понять, как postgres ведёт себя при параллельных транзакциях, какие аномалии возможны и какими приёмами их закрывают в production (микросервисы/финтех).

## как запускал
- открыл два sql editor в dbeaver: **session a** и **session b**
- проверил, что это разные сессии: `select txid_current();` (значения разные)

## key idea
в postgres (по умолчанию) **read committed**:
- *снимок данных берётся на момент старта каждого отдельного sql-запроса*,
- а не “на весь begin”.

в **repeatable read**:
- *снимок фиксируется на begin транзакции*,
- повторные select внутри транзакции видят одну и ту же картину данных.

## эксперименты

### 1) non-repeatable read (read committed)
- session a: `begin; select balance...`
- session b: `update ...; commit;`
- session a: повторил `select balance...` → значение изменилось  
**вывод:** в read committed один и тот же select в одной транзакции может увидеть новые коммиты между запросами.

### 2) repeatable read = стабильный снимок
- session a: `begin isolation level repeatable read; select ...`
- session b: `update ...; commit;`
- session a: повторил `select ...` → значение не изменилось  
**вывод:** repeatable read держит snapshot до commit/rollback.

### 3) phantom (на агрегате count)
- session a: `begin; select count(*) ...`
- session b: вставил новую строку и commit
- session a: повторил `count(*)` → стало больше на 1  
**вывод:** phantom возможен в read committed, потому что новый запрос берёт новый snapshot.

### 4) lost update (плохой паттерн read → calc → write final value)
два параллельных сценария:
- оба прочитали balance = 10000
- a записал 9000, b записал 8000
итог = 8000 (последний commit “перетёр” результат)  
**вывод:** begin/commit обеспечивает атомарность, но не спасает от гонок при неправильном паттерне обновления.

## production-паттерны фикса

### a) atomic update (предпочтительно для балансов)
вместо “прочитал → посчитал → записал итог”:
```sql
update accounts
set balance_cents = balance_cents - 1000
where id = ...;
