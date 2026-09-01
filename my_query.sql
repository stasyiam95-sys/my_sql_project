--Проект "Поиск вакансий на hh.ru"
--Выполнила Анастасия Антонова
--Определите диапазон заработных плат в общем, а именно средние значения, минимумы и максимумы нижних и верхних порогов зарплаты.
select ROUND (AVG (salary_from),2), MIN (salary_from), MAX (salary_from),
ROUND (AVG (salary_to),2), MIN (salary_to), MAX (salary_to) 
from parcing_table
--Выявите регионы и компании, в которых сосредоточено наибольшее количество вакансий.
select employer, area, count(name) as cnt--over (partition by employer, area) as cnt
from parcing_table
group by employer, area
order by cnt desc
--Проанализируйте, какие преобладают типы занятости, а также графики работы.
select schedule, employment, count(*) as cnt
from parcing_table
group by schedule, employment
order by cnt desc 
--Изучите распределение грейдов (Junior, Middle, Senior) среди аналитиков данных и системных аналитиков.
select experience, count (id)
from parcing_table
group by experience
order by experience 
--Выявите основных работодателей, предлагаемые зарплаты и условия труда для аналитиков.
select employer, employment, schedule, max(salary_to), min(salary_from), 
sum (count (name)) over (partition by employer) as vacancy
from parcing_table
group by employer, employment, schedule
order by vacancy desc 
limit 10
--Определите наиболее востребованные навыки (как жёсткие, так и мягкие) для различных грейдов и позиций.--
with skills as
(select key_skills_1 as skill_name, 'hard' as skill_type 
from parcing_table 
union 
select key_skills_2 as skill_name, 'hard' as skill_type 
from parcing_table 
union 
select key_skills_3 as skill_name, 'hard' as skill_type 
from parcing_table 
union
select key_skills_4 as skill_name, 'hard' as skill_type 
from parcing_table 
union
select soft_skills_1 as skill_name, 'soft' as skill_type 
from parcing_table 
union 
select soft_skills_2 as skill_name, 'soft' as skill_type 
from parcing_table 
union 
select soft_skills_3 as skill_name, 'soft' as skill_type 
from parcing_table 
union select soft_skills_4 as skill_name, 'soft' as skill_type 
from parcing_table),
vacancy_count as
(select experience, skill_name, skill_type, count (distinct id) as vacancy
from skills 
join parcing_table 
on skill_name = key_skills_1 
or skill_name = key_skills_2
or skill_name = key_skills_3
or skill_name = key_skills_4
or skill_name = soft_skills_1 
or skill_name = soft_skills_2
or skill_name = soft_skills_3
or skill_name = soft_skills_4
group by experience, skill_name, skill_type
order by experience, skill_type, vacancy desc),
ranked as
(select * , rank () over (partition by experience, skill_type order by vacancy desc) as rnk
from vacancy_count)
select * 
from ranked 
where rnk <= 3






