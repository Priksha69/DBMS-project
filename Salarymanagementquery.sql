-- 1. Get all employee names and their total salary
SELECT e.emp_id, e.name, s.total_salary
FROM Employee e
LEFT JOIN Salary s ON e.emp_id = s.emp_id;

-- 2. Update salary of an employee
UPDATE Salary 
SET basic_salary = 5500, bonus = 550, deductions = 100 
WHERE emp_id = 101;

-- 3. Delete an employee and cascade related records
DELETE FROM Employee 
WHERE email = 'alice.brown@example.com';

-- 4. Select employee, department, and total salary
SELECT e.name, d.dept_name, s.total_salary 
FROM Employee e 
JOIN EmployeeDepartment ed ON e.emp_id = ed.emp_id 
JOIN Department d ON ed.dept_id = d.dept_id 
JOIN Salary s ON e.emp_id = s.emp_id;

-- 5. Select employee names and their positions
SELECT e.name, p.position_name 
FROM Employee e 
JOIN Position p ON e.emp_id = p.emp_id;

-- 6. Total salary of all employees per department
SELECT d.dept_name, SUM(s.total_salary) AS total_salary 
FROM Department d 
JOIN EmployeeDepartment ed ON d.dept_id = ed.dept_id 
JOIN Employee e ON ed.emp_id = e.emp_id 
JOIN Salary s ON e.emp_id = s.emp_id 
GROUP BY d.dept_name;

-- 7. Employees who joined after 2021
SELECT name, date_of_joining 
FROM Employee 
WHERE date_of_joining > '2021-01-01';

-- 8. List all female employees
SELECT name 
FROM Employee 
WHERE gender = 'female';

-- 9. Count of employees per department
SELECT d.dept_name, COUNT(*) AS total_employees 
FROM Department d 
JOIN EmployeeDepartment ed ON d.dept_id = ed.dept_id 
GROUP BY d.dept_name;

-- 10. Top 3 employees by salary
SELECT e.name, s.total_salary 
FROM Employee e 
JOIN Salary s ON e.emp_id = s.emp_id 
ORDER BY s.total_salary DESC 
LIMIT 3;

-- 11. Find employees whose salary is more than 7000
SELECT e.name, s.total_salary 
FROM Employee e 
JOIN Salary s ON e.emp_id = s.emp_id 
WHERE s.total_salary > 7000;

-- 12. Find employees working in California
SELECT name 
FROM Employee 
WHERE address LIKE '%California%';

-- 13. List employee names and their joining year
SELECT name, YEAR(date_of_joining) AS joining_year 
FROM Employee;

-- 14. Average salary in each department
SELECT d.dept_name, AVG(s.total_salary) AS avg_salary 
FROM Department d 
JOIN EmployeeDepartment ed ON d.dept_id = ed.dept_id 
JOIN Salary s ON ed.emp_id = s.emp_id 
GROUP BY d.dept_name;

-- 15. Find departments without any employees (if any)
SELECT dept_name 
FROM Department 
WHERE dept_id NOT IN (
    SELECT DISTINCT dept_id FROM EmployeeDepartment
);
