-- Retirement eligibility
-- Determined that anyone born between 1952 and 1955, and also hired between 1985-1988 will begin to retire
SELECT count(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- 1952 birthdates
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';
-- 1953 birthdates
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';
-- 1954 birthdates
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';
-- 1955 birthdates
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';




-- Creating new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');




-- Joining departments and dept_manager tables
SELECT departments.dept_name,
    dept_manager.emp_no,
    dept_manager.from_date,
    dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
-- Creates new table current_emp to see who is still employeed with PH
SELECT retirement_info.emp_no,
    retirement_info.first_name,
    retirement_info.last_name,
    dept_employees.to_date
INTO current_emp
FROM retirement_info
LEFT JOIN dept_employees
ON retirement_info.emp_no = dept_employees.emp_no
WHERE dept_employees.to_date = ('9999-01-01');

-- Employee count by department number
-- Creates new table emp_count
SELECT de.dept_no, COUNT(ce.emp_no)
INTO emp_count
FROM current_emp as ce
LEFT JOIN dept_employees as de ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;






-- Employee Information
-- A list of employees containing their info
SELECT e.emp_no, 
       e.last_name,
       e.first_name,
       e.gender,
       s.salary,
       de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON s.emp_no = e.emp_no
INNER JOIN dept_employees as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');



-- Management
-- A list of managers for each dept.
SELECT 
dm.dept_no, dept.dept_name,
dm.emp_no, ce.last_name, ce.first_name,
dm.from_date, dm.to_date
INTO manager_info
FROM dept_manager as dm
INNER JOIN current_emp as ce 
    ON ce.emp_no = dm.emp_no
INNER JOIN departments as dept 
    ON dept.dept_no = dm.dept_no;
-- *Showing only 5 departments with active managers*



-- Department Retirees
-- Updated current_emp list that includes the employees' departments
SELECT ce.*, de.dept_no, dept.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_employees as de
ON de.emp_no = ce.emp_no
INNER JOIN departments as dept
ON dept.dept_no = de.dept_no;
-- Some employees are appearing twice
-- example - emp_no 10070 showing for two deparments development and research. 





-- Retiring Sales Employees
-- retirement_info table tailored for the Sales team
SELECT ri.*, d.dept_name
FROM retirement_info as ri
INNER JOIN dept_employees as de
ON ri.emp_no = de.emp_no
INNER JOIN departments as d
ON d.dept_no = de.dept_no
WHERE d.dept_name = 'Sales';


-- Retiring Sales + Development employees 
-- Sales and Development dept. heads request
-- The managers would like to try a new mentoring program for employees getting ready to retire
-- instead of having a large number of the workforce retiring, they will step back into a part-time role.
-- Experienced and successful employees will mentor those newly hired.
SELECT ri.*, d.dept_name
INTO sales_dev_retiring_emp
FROM retirement_info as ri
INNER JOIN dept_employees as de
ON ri.emp_no = de.emp_no
INNER JOIN departments as d
ON d.dept_no = de.dept_no
WHERE d.dept_name IN ('Sales', 'Development');