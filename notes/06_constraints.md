# урок 6 — constraints

constraints = правила, которые postgres проверяет при insert/update.

основные виды:
- not null: значение обязательно
- unique: значения (или набор значений) не повторяются
- check: логическое условие для значения
- foreign key: ссылка на строку в другой таблице

как задаются:
- not null чаще пишут рядом с колонкой в create table
- not null можно включить через alter table ... alter column ... set not null
- unique/check/fk удобно задавать как constraint с именем:
  alter table ... add constraint <name> unique/check/foreign key ...

зачем:
база защищает данные даже если приложение ошиблось ( или код забаган)
