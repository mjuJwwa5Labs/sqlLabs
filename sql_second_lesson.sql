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
	select d.dept_name, count(distinct dm.emp_no)  'ilosc_pracownikow', sum(s.salary) 'zarobki total dzialu'
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