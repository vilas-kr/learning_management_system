use lms_db;
go

BULK INSERT lms.users
FROM 'D:\Bridgelabs\Practice problem\database\lms_db\users.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);
GO

BULK INSERT lms.course
FROM 'D:\Bridgelabs\Practice problem\database\lms_db\dataset\courses.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);
GO

BULK INSERT lms.assessment
FROM 'D:\Bridgelabs\Practice problem\database\lms_db\dataset\assessments.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);
GO

BULK INSERT lms.enrollment
FROM 'D:\Bridgelabs\Practice problem\database\lms_db\dataset\enrollments.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);
GO

BULK INSERT lms.lesson
FROM 'D:\Bridgelabs\Practice problem\database\lms_db\dataset\lessons.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);
GO

BULK INSERT lms.assessment_submit
FROM 'D:\Bridgelabs\Practice problem\database\lms_db\dataset\assessment_submissions.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);
GO

BULK INSERT lms.user_activity
FROM 'D:\Bridgelabs\Practice problem\database\lms_db\dataset\user_activity.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);
GO





