-- Number of Retiring Employees by Title
--   Employees born between 1/1/1952 - 12/31/1955
--   Incluing only current employees(to_date = 9999-01-01)

-- Retirement titles
SELECT e.emp_no, e.first_name, e.last_name,
t.title, t.from_date, t.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as t
ON e.emp_no = t.emp_no
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY e.emp_no;


-- Unique Titles 
-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no) rt.emp_no, rt.first_name, rt.last_name, rt.title
INTO unique_titles
FROM retirement_titles as rt
WHERE rt.to_date = '9999-01-01'
ORDER BY rt.emp_no, rt.from_date DESC;



-- Number of employees that are about to retire (by most recent job title)
SELECT title, COUNT(emp_no)
INTO retiring_titles_count
FROM unique_titles
GROUP BY title
ORDER BY COUNT(emp_no) DESC;




-- Employees Eligible for the Mentorship Program
-- Current employees born between 1/1/1965 - 12/31/1965
SELECT DISTINCT ON (e.emp_no) e.emp_no, e.first_name, e.last_name, e.birth_date,
de.from_date, de.to_date,
t.title
INTO mentorship_eligibility
FROM employees as e
INNER JOIN dept_employees as de
ON e.emp_no = de.emp_no
INNER JOIN titles as t
ON e.emp_no = t.emp_no
WHERE (de.to_date = '9999-01-01')
AND e.birth_date BETWEEN '1965-01-01' AND '1965-12-31'
ORDER BY e.emp_no, to_date DESC;