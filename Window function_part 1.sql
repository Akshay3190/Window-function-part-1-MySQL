DROP database 4f_p;
CREATE DATABASE window_part_1;
USE window_part_1;
CREATE TABLE employee (Emp_id int, Emp_name varchar  (50), Emp_dept varchar (50), Salary int) ;
INSERT INTO employee (Emp_id, Emp_name, Emp_dept, Salary)
VALUES (101, 'Mohan', 'Admin', 4000),
(102, 'Rajkumar', 'HR', 3000),
(103, 'Akbar', 'IT', 4000),
(104, 'Dorvin', 'Finance', 6500),
(105, 'Rohit', 'HR', 3000),
(106, 'Rajesh', 'Finance', 5000),
(107, 'Preet', 'HR', 7000),
(108, 'Maryam', 'Admin', 4000),
(109, 'Sanjay', 'IT', 6500),
(110, 'Vasudha', 'IT', 7000),
(111, 'Melinda', 'IT', 8000),
(112, 'Konal', 'IT', 10000),
(113, 'Gautham', 'Admin', 2000),
(114, 'Manisha', 'HR', 3000),
(115, 'CHandani', 'IT', 4500),
(116, 'Satya', 'Finance', 6500),
(117, 'Adarsh', 'HR', 3500),
(118, 'Tejaswi', 'Finance', 5500),
(119, 'Cory', 'HR', 8000),
(120, 'Monica', 'Admin', 5000),
(121, 'Rosalin', 'IT', 6000),
(122, 'Ibrahim', 'IT', 8000),
(123, 'Vikram', 'IT', 8000),
(124, 'Dheeraj', 'IT', 11000);

SELECT * FROM employee;

-- Using aggregate  function as Window function
-- Without Window function SQL will reduce number of records
SELECT Emp_dept, MAX(salary) as max_sal from employee GROUP BY Emp_dept ORDER BY max_sal DESC;

-- By using MAX as Window function, SQL will not reduce records but the result will be shown corresponding to each record
SELECT e.*, MAX(salary) OVER () as max_sal FROM employee e;

SELECT e.*, MAX(Salary) OVER(Partition by Emp_dept) as max_sal FROM employee e;

-- row_number(), rank() and dense_rank()
SELECT e.*, row_number () OVER () as rn FROM employee e;
SELECT e.*, row_number () OVER (partition by Emp_dept ORDER BY Emp_id) as rn FROM employee e;

-- Fetch the first 2 employees from each department to join the company.
SELECT * FROM (
SELECT e.*, row_number () OVER (partition by Emp_dept ORDER BY Emp_id) as rn FROM employee e )  x
WHERE x.rn < 3;

-- Fetch the top 3 employees in each department earning the max salary.
SELECT * FROM (
SELECT e.*, rank () OVER (partition by Emp_dept ORDER BY salary DESC) as rnk FROM employee e )  x
WHERE x.rnk < 4;

-- Fetch the top 2 employees in each department earning the min salary.

SELECT * FROM (
SELECT e.*, rank ()  OVER (partition by Emp_dept ORDER BY salary) as rnk FROM employee e ) x
WHERE x.rnk < 3;

-- Checking the different between rank, dense_rnk and row_number window functions:
SELECT e.*,
rank ()  OVER (partition by Emp_dept ORDER BY salary DESC) as rnk,
dense_rank ()  OVER (partition by Emp_dept ORDER BY salary DESC) as dense_rnk,
row_number () OVER (partition by Emp_dept ORDER BY salary DESC) as rn
FROM employee e;

-- lead and lag

-- fetch a query to display if the salary of an employee is higher, lower or equal to the previous employee.
SELECT e.*,
LAG (salary) OVER (PARTITION BY Emp_dept ORDER BY EMp_id) as prev_emp_salary
FROM employee e;

SELECT e.*,
LAG (salary) OVER (partition by Emp_dept ORDER BY Emp_id ) as prev_emp_sal,
CASE WHEN e.salary > LAG (salary) OVER (partition by Emp_dept ORDER BY EMp_id ) THEN 'Higher than previous emplpyee'
     WHEN e.salary < LAG (salary) OVER (partition by Emp_dept ORDER BY EMp_id ) THEN 'Lower than previous emplpyee'
     WHEN e.salary = LAG (salary) OVER (partition by Emp_dept ORDER BY EMp_id ) THEN 'Similar to previous emplpyee' END AS sal_range
FROM employee e;

SELECT e.*,
LAG (salary) OVER (partition by Emp_dept ORDER BY Emp_id ) as prev_emp_sal,
CASE WHEN e.salary > LAG (salary) OVER (partition by Emp_dept ORDER BY EMp_id ) THEN 'Higher than previous employee'
     WHEN e.salary < LAG (salary) OVER (partition by Emp_dept ORDER BY EMp_id ) THEN 'Lower than previous employee'
     WHEN e.salary = LAG (salary) OVER (partition by Emp_dept ORDER BY EMp_id ) THEN 'Similar to previous employee' 
     WHEN e.salary = Salary THEN 'No Change' END AS sal_range
FROM employee e;   

-- fetch a query to display if the salary of an employee is higher, lower or equal to the next employee.
SELECT e.*,
LEAD (salary) OVER (partition by Emp_dept Order by Emp_id) as next_emp_salary
FROM employee e;

SELECT e.*,
LEAD (salary) OVER (partition by Emp_dept Order by Emp_id) as next_emp_salary,
CASE WHEN e.salary > LEAD (salary) OVER (partition by Emp_dept Order by Emp_id) THEN 'Higher than next employee'
     WHEN e.salary < LEAD (salary) OVER (partition by Emp_dept Order by Emp_id) THEN 'Lower than next employee'
     WHEN e.salary = LEAD (salary) OVER (partition by Emp_dept Order by Emp_id) THEN 'Similar to next employee'
     WHEN e.salary = Salary  THEN 'No Change' END AS Sal_range
FROM employee e;     


 -- Similarly using lead function to see how it is different from lag.
SELECT e.*,
LAG (salary) OVER (partition by Emp_dept ORDER BY Emp_id ) as prev_emp_sal,
LEAD (salary) OVER (partition by Emp_dept ORDER BY Emp_id ) as next_emp_sal
FROM employee e;





