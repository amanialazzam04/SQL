-- Task 2.1: Create Departments
USE TechWorldHRDB;
GO

CREATE TABLE Departments
(
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL UNIQUE
);
GO

-- Task 2.2: Create Employees
CREATE TABLE Employees
(
    EmployeeID INT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Salary DECIMAL(10,2),
    DepartmentID INT
);
GO

-- Task 2.3: Add PhoneNumber
ALTER TABLE Employees
ADD PhoneNumber VARCHAR(20);
GO

-- Task 3.1: Insert Departments

USE TechWorldHRDB;
GO

INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance');
GO


-- Task 3.2: Insert Employees

USE TechWorldHRDB;
GO

INSERT INTO Employees
    (EmployeeID, FullName, Email, Salary, DepartmentID, PhoneNumber)
VALUES
    (1, 'Ahmad Ali', 'ahmad@techworld.com', 1200.00, 1, '0791111111'),
    (2, 'Sara Hassan', 'sara@techworld.com', 950.00, 2, '0792222222'),
    (3, 'Zaid Omar', 'zaid@techworld.com', 1500.00, 1, '0793333333'),
    (4, 'Mona Khaled', 'mona@techworld.com', 800.00, 3, '0794444444');
GO

-- Task 3.3: Update Salary

USE TechWorldHRDB;
GO

UPDATE Employees
SET Salary = 1350.00
WHERE EmployeeID = 1;
GO
-- Task 3.4: Delete Record
USE TechWorldHRDB;
GO

DELETE FROM Employees
WHERE EmployeeID = 4;


-- Task 4.1: Retrieve All Employee Records

USE TechWorldHRDB;
GO

SELECT * FROM Employees;

-- Task 4.2: Retrieve Specific Columns

SELECT FullName, Salary
FROM Employees;

-- Task 4.3: Total Payroll Expense

SELECT SUM(Salary) AS TotalSalaries
FROM Employees;

-- Task 4.4: Average Employee Salary

SELECT AVG(Salary) AS AverageSalary
FROM Employees;
-- Task 4.5: Salary Range Extremes

SELECT
    MAX(Salary) AS HighestSalary,
    MIN(Salary) AS LowestSalary
FROM Employees;

-- Task 4.6: Total Headcount

SELECT COUNT(*) AS TotalEmployees
FROM Employees;