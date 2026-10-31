USE TechWorldHRDB;
GO

SELECT * FROM Departments;
SELECT * FROM Employees;

CREATE TABLE AccessCards
(
    CardID INT PRIMARY KEY,
    CardNumber VARCHAR(50) NOT NULL UNIQUE,
    EmployeeID INT UNIQUE,

    CONSTRAINT FK_AccessCards_Employees
    FOREIGN KEY (EmployeeID)
    REFERENCES Employees(EmployeeID)
);

CREATE TABLE Projects
(
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL
);
CREATE TABLE EmployeeProjects
(
    EmployeeID INT,
    ProjectID INT,
    AssignedDate DATE,

    CONSTRAINT PK_EmployeeProjects
    PRIMARY KEY (EmployeeID, ProjectID),

    CONSTRAINT FK_EmployeeProjects_Employees
    FOREIGN KEY (EmployeeID)
    REFERENCES Employees(EmployeeID),

    CONSTRAINT FK_EmployeeProjects_Projects
    FOREIGN KEY (ProjectID)
    REFERENCES Projects(ProjectID)
);
INSERT INTO AccessCards (CardID, CardNumber, EmployeeID)
VALUES
(101, 'CARD-101', 1),
(102, 'CARD-102', 2),
(103, 'CARD-103', 3);

SELECT * FROM AccessCards;

INSERT INTO Projects (ProjectID, ProjectName)
VALUES
(1, 'AI & Security Training'),
(2, 'Cloud Migration');
SELECT * FROM Projects;

INSERT INTO EmployeeProjects (EmployeeID, ProjectID, AssignedDate)
VALUES
(1, 1, GETDATE()),
(1, 2, GETDATE()),
(2, 1, GETDATE()),
(3, 2, GETDATE());

SELECT * FROM EmployeeProjects;

SELECT
    Employees.FullName,
    Employees.Salary,
    Departments.DepartmentName
FROM Employees
INNER JOIN Departments
    ON Employees.DepartmentID = Departments.DepartmentID;

    SELECT
    Departments.DepartmentName,
    Employees.FullName
FROM Departments
LEFT JOIN Employees
    ON Departments.DepartmentID = Employees.DepartmentID;

    SELECT
    Employees.FullName,
    AccessCards.CardNumber
FROM Employees
INNER JOIN AccessCards
    ON Employees.EmployeeID = AccessCards.EmployeeID;


SELECT
    Employees.FullName,
    Projects.ProjectName,
    EmployeeProjects.AssignedDate
FROM Employees
INNER JOIN EmployeeProjects
    ON Employees.EmployeeID = EmployeeProjects.EmployeeID
INNER JOIN Projects
    ON EmployeeProjects.ProjectID = Projects.ProjectID;

    SELECT
    DepartmentID,
    SUM(Salary) AS TotalSalary,
    COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentID;

SELECT
    DepartmentID,
    AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentID
HAVING AVG(Salary) > 1000.00;


SELECT *
FROM Employees
WHERE Salary > 
(
    SELECT AVG(Salary)
    FROM Employees
);


GO

CREATE VIEW vw_EmployeeDetails
AS
SELECT
    E.EmployeeID,
    E.FullName,
    E.Email,
    D.DepartmentName
FROM Employees AS E
INNER JOIN Departments AS D
    ON E.DepartmentID = D.DepartmentID;
GO

SELECT * FROM vw_EmployeeDetails;

GO

CREATE PROCEDURE sp_GetEmployeesByDepartment
    @DeptID INT
AS
BEGIN
    SELECT *
    FROM Employees
    WHERE DepartmentID = @DeptID;
END;
GO

EXEC sp_GetEmployeesByDepartment @DeptID = 1;

CREATE TABLE EmployeeAudit
(
    AuditID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT,
    Action VARCHAR(50),
    ActionDate DATETIME
);


GO

CREATE TRIGGER trg_AfterEmployeeDelete
ON Employees
AFTER DELETE
AS
BEGIN
    INSERT INTO EmployeeAudit
        (EmployeeID, Action, ActionDate)
    SELECT
        EmployeeID,
        'DELETE',
        GETDATE()
    FROM deleted;
END;
GO
SELECT name
FROM sys.triggers
WHERE name = 'trg_AfterEmployeeDelete';
