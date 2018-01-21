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