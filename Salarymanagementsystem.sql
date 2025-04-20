-- Create the Database
CREATE DATABASE SMS;
USE SMS;

-- Create the Employee Table
CREATE TABLE Employee(
    emp_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    address VARCHAR(100) NOT NULL,
    gender VARCHAR(20) NOT NULL CHECK (gender IN ('male', 'female', 'other')),
    date_of_joining DATE NOT NULL
);

-- Create the Department Table
CREATE TABLE Department(
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(50) NOT NULL
);

-- Create the Salary Table
CREATE TABLE Salary(
    salary_id INT PRIMARY KEY,
    emp_id INT NOT NULL,
    basic_salary DECIMAL(10, 2) NOT NULL CHECK (basic_salary >= 0),
    bonus DECIMAL(10, 2) NOT NULL CHECK (bonus >= 0),
    deductions DECIMAL(10, 2) NOT NULL CHECK (deductions >= 0),
    total_salary DECIMAL(10, 2) GENERATED ALWAYS AS (basic_salary + bonus - deductions) STORED,
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id) ON DELETE CASCADE
);

-- Create the Position Table (typo fixed here)
CREATE TABLE `Position` (
    pos_id INT PRIMARY KEY,
    emp_id INT NOT NULL,
    position_name VARCHAR(50) NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id) ON DELETE CASCADE
);

-- Create the EmployeeDepartment Table
CREATE TABLE EmployeeDepartment (
    emp_id INT NOT NULL,
    dept_id INT NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id) ON DELETE CASCADE,
    PRIMARY KEY (emp_id, dept_id)
);

-- Insert into Employee Table
INSERT INTO Employee(emp_id, name, email, address, gender, date_of_joining)
VALUES
    (101, 'John Doe', 'john.doe@example.com', '1234 Elm Street, California', 'male', '2020-05-20'),
    (102, 'Jane Smith', 'jane.smith@example.com', '5678 Oak Avenue, New York', 'female', '2019-07-15'),
    (103, 'Mike Johnson', 'mike.johnson@example.com', '4321 Pine Road, Texas', 'male', '2021-01-10'),
    (104, 'Alice Brown', 'alice.brown@example.com', '7890 Maple Street, California', 'female', '2022-03-01'),
    (105, 'David Clark', 'david.clark@example.com', '1234 Birchwood, Florida', 'male', '2020-08-12'),
    (106, 'Sarah Miller', 'sarah.miller@example.com', '8765 Cedar Blvd, Nevada', 'female', '2021-06-20'),
    (107, 'Emily White', 'emily.white@example.com', '3456 Redwood Drive, Ohio', 'female', '2019-09-25'),
    (108, 'Daniel King', 'daniel.king@example.com', '2345 Fir Avenue, Arizona', 'male', '2022-07-13'),
    (109, 'Sophia Green', 'sophia.green@example.com', '5432 Maple Avenue, Texas', 'female', '2020-01-30'),
    (110, 'James Adams', 'james.adams@example.com', '4567 Oak Street, California', 'male', '2021-02-12'),
    (111, 'Benjamin Scott', 'benjamin.scott@example.com', '8901 Pine Lane, Georgia', 'male', '2021-11-01'),
    (112, 'Charlotte Carter', 'charlotte.carter@example.com', '1357 Oak Blvd, Michigan', 'female', '2022-05-25');

-- Insert into Department Table
INSERT INTO Department(dept_id, dept_name, location)
VALUES
    (11, 'Human Resources', 'California'),
    (12, 'Finance', 'New York'),
    (13, 'Engineering', 'Texas');

-- Insert into Salary Table
INSERT INTO Salary(salary_id, emp_id, basic_salary, bonus, deductions)
VALUES
    (201, 101, 5000, 500, 200),
    (202, 102, 6000, 600, 250),
    (203, 103, 7000, 700, 300),
    (204, 104, 6500, 650, 150),
    (205, 105, 7500, 750, 100),
    (206, 106, 8000, 800, 350),
    (207, 107, 5500, 500, 200),
    (208, 108, 6700, 670, 150),
    (209, 109, 7200, 720, 250),
    (210, 110, 7800, 780, 300),
    (211, 111, 8200, 820, 400),
    (212, 112, 8800, 880, 450);

-- Insert into Position Table
INSERT INTO `Position`(pos_id, emp_id, position_name)
VALUES
    (301, 101, 'HR Manager'),
    (302, 102, 'Financial Analyst'),
    (303, 103, 'Software Engineer'),
    (304, 104, 'Marketing Executive'),
    (305, 105, 'HR Assistant'),
    (306, 106, 'Financial Manager'),
    (307, 107, 'Content Writer'),
    (308, 108, 'Software Developer'),
    (309, 109, 'Accountant'),
    (310, 110, 'Financial Planner'),
    (311, 111, 'Web Developer'),
    (312, 112, 'Project Manager');


-- Insert into EmployeeDepartment Table
INSERT INTO EmployeeDepartment(emp_id, dept_id)
VALUES
    (101, 11), (102, 12), (103, 13),
    (104, 13), (105, 11), (106, 12),
    (107, 11), (108, 13), (109, 12),
    (110, 13), (111, 12), (112, 11);

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
