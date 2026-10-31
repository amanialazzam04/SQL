USE CourseHubDB;
GO

CREATE TABLE TempInstructors
(
    TempID INT,
    TempName VARCHAR(50),
    JoinedDate DATE
);
SELECT * FROM TempInstructors;

CREATE TABLE Departments
(
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE
);
SELECT * FROM Departments;

CREATE TABLE Students
(
    StudentID INT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    GPA DECIMAL(3,2),
    DepartmentID INT,

    CONSTRAINT FK_Students_Departments
    FOREIGN KEY (DepartmentID)
    REFERENCES Departments(DepartmentID)
);

CREATE TABLE StudentProfiles
(
    ProfileID INT PRIMARY KEY,
    StudentID INT UNIQUE,
    Address VARCHAR(200),
    EmergencyPhone VARCHAR(20),

    CONSTRAINT FK_StudentProfiles_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students(StudentID)
);

CREATE TABLE Courses
(
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    Credits INT,
    DepartmentID INT,

    CONSTRAINT FK_Courses_Departments
    FOREIGN KEY (DepartmentID)
    REFERENCES Departments(DepartmentID)
);

CREATE TABLE StudentCourses
(
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE DEFAULT GETDATE(),

    CONSTRAINT PK_StudentCourses
    PRIMARY KEY (StudentID, CourseID),

    CONSTRAINT FK_StudentCourses_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students(StudentID),

    CONSTRAINT FK_StudentCourses_Courses
    FOREIGN KEY (CourseID)
    REFERENCES Courses(CourseID)
);

ALTER TABLE Students
ADD Age INT;

DROP TABLE TempInstructors;

INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES
(1, 'Computer Science'),
(2, 'Software Engineering'),
(3, 'Business Administration');

SELECT * FROM Departments;

INSERT INTO Students
(StudentID, FullName, Email, GPA, DepartmentID, Age)
VALUES
(101, 'Ali Smadi', 'ali@coursehub.com', 3.80, 1, 22),
(102, 'Omar Ahmad', 'omar@coursehub.com', 2.90, 1, 21),
(103, 'Laila Hassan', 'laila@coursehub.com', 3.50, 2, 23),
(104, 'Tariq Zaid', 'tariq@coursehub.com', 2.10, 3, 20);


SELECT * FROM Students;

INSERT INTO StudentProfiles
(ProfileID, StudentID, Address, EmergencyPhone)
VALUES
(1, 101, 'Amman, Jordan', '0791111111'),
(2, 102, 'Irbid, Jordan', '0792222222'),
(3, 103, 'Zarqa, Jordan', '0793333333');

SELECT * FROM StudentProfiles;

INSERT INTO Courses
(CourseID, CourseName, Credits, DepartmentID)
VALUES
(201, 'Database Systems', 3, 1),
(202, 'Web Development', 3, 1),
(203, 'Software Architecture', 3, 2);

SELECT * FROM Courses;


INSERT INTO StudentCourses (StudentID, CourseID)
VALUES
(101, 201),
(101, 202),
(102, 201),
(103, 203);

SELECT * FROM StudentCourses;

UPDATE Students
SET GPA = 2.50
WHERE StudentID = 104;

SELECT * FROM Students
WHERE StudentID = 104;

DELETE FROM Students
WHERE StudentID = 104;

SELECT * FROM Students;

SELECT
    Students.FullName,
    Students.GPA,
    Departments.DepartmentName
FROM Students
INNER JOIN Departments
    ON Students.DepartmentID = Departments.DepartmentID;


    SELECT
    Departments.DepartmentName,
    Students.FullName
FROM Departments
LEFT JOIN Students
    ON Departments.DepartmentID = Students.DepartmentID;

    SELECT
    Students.FullName,
    StudentProfiles.Address,
    StudentProfiles.EmergencyPhone
FROM Students
INNER JOIN StudentProfiles
    ON Students.StudentID = StudentProfiles.StudentID;


    SELECT
    Students.FullName,
    Courses.CourseName,
    StudentCourses.EnrollmentDate
FROM Students
INNER JOIN StudentCourses
    ON Students.StudentID = StudentCourses.StudentID
INNER JOIN Courses
    ON StudentCourses.CourseID = Courses.CourseID;

    SELECT
    COUNT(*) AS TotalStudents,
    AVG(GPA) AS AverageGPA,
    MAX(GPA) AS HighestGPA,
    MIN(GPA) AS LowestGPA
FROM Students;


SELECT
    DepartmentID,
    AVG(GPA) AS AverageGPA,
    COUNT(*) AS TotalStudents
FROM Students
GROUP BY DepartmentID;


SELECT
    DepartmentID,
    AVG(GPA) AS AverageGPA
FROM Students
GROUP BY DepartmentID
HAVING AVG(GPA) > 3.00;



SELECT
    DepartmentID,
    COUNT(*) AS TotalStudents
FROM Students
WHERE GPA >= 2.50
GROUP BY DepartmentID
HAVING COUNT(*) > 1;


SELECT
    name,
    type_desc
FROM sys.indexes
WHERE object_id = OBJECT_ID('Students');

CREATE NONCLUSTERED INDEX IX_Students_Email
ON Students(Email);

EXEC sp_helpindex 'Students';

SELECT *
FROM Students
WHERE GPA >
(
    SELECT AVG(GPA)
    FROM Students
);

GO

CREATE VIEW vw_StudentAcademicDetails
AS
SELECT
    Students.StudentID,
    Students.FullName,
    Students.GPA,
    Departments.DepartmentName
FROM Students
INNER JOIN Departments
    ON Students.DepartmentID = Departments.DepartmentID;
GO

SELECT * FROM vw_StudentAcademicDetails;

GO
CREATE PROCEDURE sp_GetStudentsByDepartment
    @DeptID INT
AS
BEGIN
    SELECT *
    FROM Students
    WHERE DepartmentID = @DeptID;
END;
GO

EXEC sp_GetStudentsByDepartment @DeptID = 1;



