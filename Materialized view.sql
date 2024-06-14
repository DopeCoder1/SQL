create table hash_table(
	key int,	
	value decimal
);

drop table hash_table;
drop materialized view m_view_hash_table;

--Генерация 50 млн рандомных записей
insert into hash_table (key, value)
select 1, random() from generate_series(1, 30000000);

insert into hash_table (key, value)
select 2, random() from generate_series(1, 20000000);

select key, avg(value), count(*)
from hash_table
group by key;

explain select key, avg(value), count(*)
from hash_table
group by key;

--materialized view хранит у себя:
--1)Запрос представление
--2)Результат запроса

--cоздание materialized view
create materialized view m_view_hash_table as 
select key, avg(value), count(*)
from hash_table
group by key;

select * from m_view_hash_table;

explain select * from m_view_hash_table;

delete from hash_table where key = 2;

--обновление materialized view
refresh materialized view m_view_hash_table;
