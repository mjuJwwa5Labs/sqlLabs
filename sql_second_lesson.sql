-- using sample employees db
use employees;

select e.emp_no, e.first_name, e.last_name, d.dept_no, d.dept_name
from employees e
inner join dept_emp de
	on e.emp_no = de.emp_no
inner join departments d
	on de.dept_no = d.dept_no;
    
select e.emp_no, e.first_name, e.last_name, dm.from_date, dm.to_date, d.dept_no, d.dept_name
from employees e
inner join dept_manager dm
	on e.emp_no = dm.emp_no
inner join departments d
	on dm.dept_no = d.dept_no;
    
select e.emp_no, e.first_name, e.last_name, dm.from_date, dm.to_date, d.dept_no, d.dept_name, s.salary, s.from_date 'paid_from', s.to_date 'paid_to'
from employees e
inner join dept_manager dm
	using (emp_no)
inner join departments d
	using (dept_no)
inner join salaries s
	using (emp_no);
    
select *
from employees e
left join titles t
	using (emp_no);
    

select *
from employees e
left join dept_manager dm
	using (emp_no);
    
select d.dept_name, count(dm.dept_no) 'ilosc_pracownikow'
from departments d
inner join dept_emp dm
	using (dept_no)
where dm.from_date > '1991-01-01' and dm.to_date < '1991-12-31'
group by (d.dept_no)
order by count(dm.dept_no) DESC;

-- suma wypłaconych wypłat w podziale na działy wraz z ilością pracowników, 
-- która w tym okresie pracowała w danym dziale
select d.dept_name, count(distinct dm.emp_no)  'ilosc_pracownikow', sum(s.salary) 'zarobki total dzialu'
from departments d
inner join dept_emp dm
	using (dept_no)
inner join salaries s
	using (emp_no)
	where dm.from_date >= '1991-01-01' and dm.to_date <= '1991-12-31'
group by (d.dept_no)
order by count(distinct dm.emp_no) DESC;

-- suma wypłaconych wypłat w podziale na działy wraz z ilością pracowników, 
-- która w tym okresie pracowała w danym dziale, dla działów które były większe niż 30 osób
select d.dept_name, count(distinct dm.emp_no)  'ilosc_pracownikow', sum(s.salary) 'zarobki total dzialu'
from departments d
inner join dept_emp dm
	using (dept_no)
inner join salaries s
	using (emp_no)
	where dm.from_date >= '1991-01-01' and dm.to_date <= '1991-12-31'
group by (d.dept_no)
having count(distinct dm.emp_no) > 30
order by count(distinct dm.emp_no) DESC;

select * from departments;

-- ilosc pracownikow w danym dziale dla id 
-- departamentow wyciagnietych po ich nazwie
	
    -- najpierw piszę sobie podzapytanie do głównego zapytania
	select distinct dept_no 
	from departments
	where dept_name='Customer Service' 
	or dept_name='Development'
	or dept_name='Finance';

-- teraz wstawiam to w główne zapytanie
	-- v1
    select 
		d.dept_name, 
        count(distinct dm.emp_no)  'ilosc_pracownikow', 
        sum(s.salary) 'zarobki total dzialu'
	from departments d
	inner join dept_emp dm
		using (dept_no)
	inner join salaries s
		using (emp_no)
		where dm.from_date >= '1991-01-01' and dm.to_date <= '1991-12-31'
		and d.dept_no in (
			select dept_no 
			from departments
			where dept_name='Customer Service' 
			or dept_name='Development'
			or dept_name='Finance'
		)
	group by (d.dept_no)
	order by count(distinct dm.emp_no) DESC;
    
    -- v2
	select
		d.dept_name, 
		count(distinct dm.emp_no)  'ilosc_pracownikow', 
        sum(s.salary) 'zarobki total dzialu'
	from departments d
	inner join dept_emp dm
		using (dept_no)
	inner join salaries s
		using (emp_no)
		where dm.from_date >= '1991-01-01' and dm.to_date <= '1991-12-31'
		and d.dept_no in (
			select dept_no 
			from departments
			where dept_name in ('Customer Service', 'Development', 'Finance')
		)
	group by (d.dept_no)
	order by count(distinct dm.emp_no) DESC;
    
-- kolejne smutne zadanko
select d.dept_name, count(distinct de.emp_no)
from departments d
inner join dept_emp de
	using (dept_no)
where de.dept_no in (
	select d1.dept_no
	from departments d1
	where d1.dept_name in ('Development')
    )
group by d.dept_name;

-- zadanie na rozmyślanie
-- query zwroci informacje o 

-- wszyscy ktorzy byli managerami
select distinct de.emp_no 
from dept_emp de
left join dept_manager dm
using (emp_no)
where dm.dept_no is not null;

-- wszyscy, ktrzy nie byli managerami
select distinct de.emp_no
from dept_emp de
left join dept_manager dm
using (emp_no)
where dm.dept_no is null;

select count(e.emp_no), e.emp_no
from employees e
inner join titles t
using (emp_no)
group by e.emp_no
having count(emp_no)>1;

-- dokonczyc...
-- zbieramy imie i nazwisko, stanowisko oraz wyplate wszystkich, ktorzy nie byli managerami
-- oraz ile zarobily przez rok od dnia zatrudnienia
select
	e.emp_no,
    e.first_name,
    e.last_name,
    t.title,
    sum(s.salary)
from employees e
left join dept_manager dm
	using (emp_no)
inner join salaries s
 	using (emp_no)
inner join titles t
	using (emp_no)
where dm.dept_no is null
-- and e.emp_no = 10009
and e.hire_date + INTERVAL 365 DAY
group by e.emp_no
order by e.emp_no;

-- Assistant Engineer
-- Engineer
-- Manager
-- Senior Engineer
-- Senior Staff
-- Staff
-- Technique Leader

-- # emp_no,	'name', 			hire_date, 		salary, 	from_date, 		to_date  PRZYKŁAD PODWYŻKI W TRAKCIE PIERWSZEGO ROKU
-- '10235',		'Susanta Roccetti', '1995-04-06', 	'41941', 	'1995-04-06', 	'1996-04-04'
-- '10235',		'Susanta Roccetti', '1995-04-06', 	'45643', 	'1996-04-04',	'1997-04-04'


-- '273517'


select distinct 
	t1.emp_no 'Id Pracownika',
    concat(e.first_name, ' ',e.last_name) 'Pracownik',
    -- ROW_NUMBER() OVER(PARTITION BY e.emp_no order by e.emp_no) AS row_num1,
    t2.from_date 'Assistant Engineer od',
    t3.from_date 'Engineer od',
    t4.from_date 'Manager od',
    t5.from_date 'Senior Engineer od',
    t6.from_date 'Senior Staff od',
    t7.from_date 'Staff od',
    t8.from_date 'Technique Leader od',
    s1.salary 'Wypłaty'
    
    
    -- count(*)
    
from titles t1

inner join employees e on e.emp_no = t1.emp_no
left join titles t2 on t2.title = 'Assistant Engineer' and t1.emp_no = t2.emp_no and (t2.from_date between e.hire_date AND (e.hire_date + INTERVAL 364 DAY))
left join titles t3	on t3.title = 'Engineer' and t1.emp_no = t3.emp_no and (t3.from_date between e.hire_date AND (e.hire_date + INTERVAL 364 DAY))
left join titles t4	on t4.title = 'Manager' and t1.emp_no = t4.emp_no and (t4.from_date between e.hire_date AND (e.hire_date + INTERVAL 364 DAY))
left join titles t5	on t5.title = 'Senior Engineer' and t1.emp_no = t5.emp_no and (t5.from_date between e.hire_date AND (e.hire_date + INTERVAL 364 DAY))
left join titles t6	on t6.title = 'Senior Staff' and t1.emp_no = t6.emp_no and (t6.from_date between e.hire_date AND (e.hire_date + INTERVAL 364 DAY))
left join titles t7	on t7.title = 'Staff' and t1.emp_no = t7.emp_no and (t7.from_date between e.hire_date AND (e.hire_date + INTERVAL 364 DAY))
left join titles t8	on t8.title = 'Technique Leader' and t1.emp_no = t8.emp_no and (t8.from_date between e.hire_date AND (e.hire_date + INTERVAL 364 DAY))
inner join salaries s1 on s1.emp_no = t1.emp_no and ((s1.from_date between e.hire_date AND (e.hire_date + INTERVAL 364 DAY)))
left join dept_manager dm on s1.emp_no = dm.emp_no
where dm.emp_no is null
;


-- '170123'
-- '170123'

-- poniższa wersja jest chyba ostatecznie poprawna
select -- distinct
	-- /*
    e.emp_no 'pracownik id' ,
    concat(e.first_name,' ',e.last_name) 'pracownik',
    e.hire_date 'data zatrudnienia',
    s.salary 'wyplata przez rok od zatrudnienia',
    s.from_date 'stawka roczna od',
    s.to_date 'stawka roczna do',
    t.title 'stanowisko pelnione przez rok od zatrudnienia'
    -- */
    -- count(*)
from employees e
inner join salaries s on e.emp_no = s.emp_no and ((s.from_date between e.hire_date AND (e.hire_date + INTERVAL 364 DAY))) -- z powodu jakości danych, trzeba brać 364 dni zamiast 365 dni
left join dept_manager dm on e.emp_no = dm.emp_no
left join titles t on t.emp_no = e.emp_no and ((t.from_date between e.hire_date AND (e.hire_date + INTERVAL 364 DAY))) -- z powodu jakości danych, trzeba brać 364 dni zamiast 365 dni
left join departments d on d.dept_no = dm.dept_no
where dm.emp_no is null
group by e.emp_no
order by e.emp_no asc
;


select emp_no, title, from_date, to_date from titles where emp_no='10235';

-- managerów 		= 24
-- nie managerów 	= 331579

select de.dept_no, count(de.emp_no)	-- wybieram numer działu z dept_emp i zliczam rekordy z dept_emp
from dept_emp de 					-- zaczynam od tabeli dept_emp
left join dept_manager dm 			-- łączę się z tabelą, która ma informacje o managerach
on de.emp_no = dm.emp_no 			-- łączę się po kluczu emp_no
where dm.emp_no is null 			-- wybieram tylko te rekordy, które nie mają swojego dopasowania
									-- w dept_manager, czyli te rekordy, gdzie pracownik nie był managerem
group by de.dept_no					-- grupuje po numerze pracownika z dept_employee
;


-- 2018-01-27

-- zwraca numer znaku, na którym jest dany element
select e.emp_no, e.first_name, e.last_name, instr(e.first_name, 'rgi')
from employees e
group by e.emp_no
order by e.emp_no ASC
;

-- liczymy średnią zarobków kazdego managera za dany okres
select e.emp_no, e.first_name, e.last_name, instr(e.first_name, 'garet'), s.from_date 's.from_date', s.to_date 's.to_date', avg(s.salary)
from employees e
inner join dept_manager dm
	on e.emp_no = dm.emp_no
inner join salaries s
	on e.emp_no = s.emp_no
where s.from_date > '1989-01-01' and s.to_date < '1992-01-01'
group by e.emp_no
;

-- wylicz ile jest kobiet ile jest mężczyzn
select
	sum(case when gender = 'M' then 1 else 0 end) as 'Male',
    sum(case when gender = 'F' then 1 else 0 end) as 'Female'
from employees;

-- to samo co wyżej tylko rozszerzamy o wyliczenie stosunku male/female
select
	sum(case when gender = 'M' then 1 else 0 end) as 'Male',
    sum(case when gender = 'F' then 1 else 0 end) as 'Female',
    sum(case when gender = 'M' then 1 else 0 end)/sum(case when gender = 'F' then 1 else 0 end) as 'Male/Female'
from employees; -- czas wykonywania 0.219

-- to samo co wyżej tylko wersja Janka
SELECT Male, Female, Male/Female FROM (
SELECT
SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS 'Male',
SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS 'Female'
FROM employees) X
; -- czas wykonywania 0.157

-- szukamy wszystkich pracownikow, ktorzy maja wiecej niz 45 lat
select e.emp_no, e.birth_date, year(curdate()) - year(e.birth_date)
from employees e
where year(curdate()) - year(e.birth_date) > 45
;

