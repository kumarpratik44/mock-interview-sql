use mock_interview;
select * from  employees;
select* from departments;
select * from projects;
select * from attendance;
select * from salary_history;

-- List all employees who joined after 1st Jan 2021.

select emp_name from employees
where hire_date >'2021-01-01';

-- Show employee names with their department names (use JOIN).

select e.emp_name, e.dept_id, d.dept_name
from employees as e 
join departments as d
on e.dept_id = d.dept_id;

-- Find the highest salary in each department.


SELECT 
    MAX(e.salary) AS highest_salary, d.dept_name
FROM
    employees AS e
        JOIN
    departments AS d ON e.dept_id = d.dept_id
GROUP BY d.dept_name;

-- Count how many employees were hired in each year.

select count(e.emp_name) as total_emp, year(e.hire_date) as hired_year
from employees as e 
join departments as d
on e.dept_id = d.dept_id
group by   hired_year
order by hired_year desc;

-- Show employee name, salary, and their manager’s name.
select  e.emp_name AS employee_name, e.salary,  m.emp_name AS manager_name
from employees as e 
left join employees as m
on e.manager_id = m.emp_id;

-- Rank employees by salary in each department (highest salary = rank 1).
select*
from (
select e.emp_name, e.salary, d.dept_name,
rank() over( partition by d.dept_name order by e.salary desc)  as rnk 
from employees as e 
join departments as d
on e.dept_id = d.dept_id) t
where rnk =1;

-- Find the second highest salary in the company?
select emp_name, salary
from employees
order by salary desc
limit 1 offset 1;

-- windows function
select emp_name, salary
from (
select emp_name, salary,
rank() over ( order by salary desc) as rnk
from employees ) t
where rnk =2;

-- Show running total of salaries ordered by hire date.
select sum(salary) as total_salary, hire_date
from employees
group by hire_date
order by hire_date;

-- windows function 

select emp_name, hire_date, salary,
sum(salary) over (order by hire_date) as running_total
from employees
order by hire_date;

-- Find the average salary per department and show employees earning above that average.

select round(avg(salary),0) as avg_salary, dept_name
from(
select e.salary, d.dept_name
from employees as e
join departments as d
on e.dept_id = d.dept_id ) t
group by dept_name;

-- windows 

select emp_name, salary,  dept_name, avg_salary
from (
select e.emp_name, e.salary, d.dept_name,
round(avg(e.salary) over (partition by d.dept_name  ),0) as avg_salary
from employees as e
join departments as d
on e.dept_id = d.dept_id)  t

WHERE salary > avg_salary
ORDER BY dept_name, salary DESC;

-- Find how many employees were hired in each month of each year

select year(hire_date) as  hire_year, monthname(hire_date) as hire_month,
 count(emp_name) as total_emp
from employees
group by year(hire_date), monthname(hire_date) 
order by hire_year, hire_month;

-- Find the department-wise highest-paid employee
select emp_name, salary_rank, dept_name
from 
(select e.emp_name, e.salary, d.dept_name,
dense_rank() over(partition by d.dept_name ORDER BY e.salary DESC) as salary_rank
from employees as e
join departments as d
on e.dept_id = d.dept_id ) t
WHERE salary_rank = 1
order by dept_name desc
