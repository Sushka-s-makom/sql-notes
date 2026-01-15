# Урок 4 — joins

Связь: transactions.account_id → accounts.id (внешний ключ).

join (inner join):
- возвращает только те строки, где совпали ключи

left join:
- возвращает все строки из левой таблицы (accounts),
  даже если соответствий в правой нет (тогда поля t.* будут null)

Если в select есть агрегат (count/sum/avg), то остальные поля должны быть в group by.
