-- Insert data to all tables
USE learning_management_db;
GO 

INSERT INTO users (user_id, name, email, password) VALUES
('USER0001', 'Alice', 'alice@gmail.com', 'pass123'),
('USER0002', 'Bob', 'bob@gmail.com', 'pass456'),
('USER0003', 'Charlie', 'charlie@gmail.com', 'pass789'),
('USER0004', 'Diana', 'diana@gmail.com', 'diana123'),
('USER0005', 'Evan', 'evan@gmail.com', 'pass111'),
('USER0006', 'Frank', 'frank@gmail.com', 'pass222'),
('USER0007', 'Vilas', 'vilas@gmail.com', 'vilas123'),
('USER0008', 'Helen', 'helen@gmail.com', 'pass333'),
('USER0009', 'Ishan', 'ishan@gmail.com', 'pass444'),
('USER0010', 'Jenny', 'jenny@gmail.com', NULL);
GO

INSERT INTO course (course_id, course_name, course_title) VALUES
('CU001', 'SQL', 'Master SQL from Basics to Advanced'),
('CU002', 'JAVA', 'Complete Java Programming'),
('CU003', 'PY', NULL),
('CU004', 'DSA', 'Data Structures and Algorithms'),
('CU005', 'WEB', 'Full Stack Web Development');
GO

INSERT INTO lesson (lesson_id, course_id, lesson_title, lesson_order, duration) VALUES
('LES00001', 'CU001', 'Introduction to SQL', 1, '00:30:00'),
('LES00002', 'CU001', 'SQL Joins', 2, '00:45:00'),
('LES00003', 'CU001', 'Subqueries', 3, '01:00:56'),
('LES00004', 'CU002', 'Java Basics', 1, '01:00:00'),
('LES00005', 'CU002', 'OOP Concepts', 2, '00:50:00'),
('LES00006', 'CU003', 'Python Intro', 1, '01:40:00'),
('LES00007', 'CU001', 'Indexes & Performance', 4, '00:40:00'),
('LES00008', 'CU001', 'Stored Procedures', 5, '00:20:00'),
('LES00009', 'CU002', 'Exception Handling', 3, '00:35:00'),
('LES00010', 'CU002', 'Collections Framework', 4, '01:10:00'),
('LES00011', 'CU004', 'DSA Introduction', 1, '00:50:00'),
('LES00012', 'CU004', 'Arrays & Strings', 2, '01:00:00'),
('LES00013', 'CU005', 'HTML Basics', 1, '00:45:00'),
('LES00014', 'CU005', 'CSS Fundamentals', 2, '00:50:00');
GO

INSERT INTO enrollment (user_id, course_id, enrollment_date) VALUES
('USER0001', 'CU001', '2025-01-01 10:00:00'),
('USER0001', 'CU002', '2025-01-05 11:00:00'),
('USER0002', 'CU001', '2025-02-10 11:30:00'),
('USER0003', 'CU003', '2025-01-10 09:30:00'),
('USER0004', 'CU002', '2025-02-15 16:45:00'),
('USER0005', 'CU001', '2025-02-01 10:15:00'),
('USER0006', 'CU002', '2025-12-15 16:45:00'),
('USER0006', 'CU004', '2025-02-05 09:00:00'),
('USER0007', 'CU005', '2025-02-15 16:34:00'),
('USER0008', 'CU001', '2025-02-10 11:30:00'),
('USER0009', 'CU004', '2025-02-12 14:00:00'),
('USER0010', 'CU005', '2025-02-15 16:45:00');
GO

INSERT INTO assessment (course_id, assessment_name, max_score) VALUES
('CU001', 'SQL Basics Test', 100),
('CU001', 'SQL Advanced Test', 100),
('CU002', 'Java Fundamentals Test', 50),
('CU003', 'Python Quiz', 25),
('CU002', 'Java OOP Test', 100),
('CU004', 'DSA Basics Test', 50),
('CU004', 'Arrays Test', 50),
('CU005', 'HTML & CSS Quiz', 30);
GO

INSERT INTO assessment_submit (assessment_id, user_id, obtained_marks, submission_date) VALUES
(1, 'USER0001', 85, '2025-01-15 10:00:00'),
(1, 'USER0002', 70, '2025-01-27 09:00:00'),
(2, 'USER0001', 90, '2025-01-20 12:00:00'),
(3, 'USER0004', NULL, '2025-06-25 10:00:00'),
(4, 'USER0003', 20, '2025-01-25 09:00:00'),
(5, 'USER0001', 78, '2025-02-03 10:00:00'),
(5, 'USER0006', NULL, '2025-01-25 09:00:00'),
(6, 'USER0006', 45, '2025-02-07 09:30:00'),
(7, 'USER0009', 40, '2025-01-25 09:10:00'),
(8, 'USER0010', 25, '2025-02-16 17:00:00');
GO

INSERT INTO user_activity (user_id, course_id, lesson_id, activity_status, activity_date) VALUES
('USER0001', 'CU001', 'LES00001', 'started', '2025-01-02 10:00:00'),
('USER0001', 'CU001', 'LES00002', 'started', '2025-01-02 08:30:00'),
('USER0002', 'CU001', 'LES00001', 'started', '2025-01-03 09:00:00'),
('USER0003', 'CU003', 'LES00006', 'completed', '2025-02-02 10:30:00'),
('USER0004', 'CU002', 'LES00004', 'started', '2025-01-06 08:30:00'),
('USER0005', 'CU001', 'LES00001', 'started', '2025-02-02 09:00:00'),
('USER0005', 'CU001', 'LES00002', 'completed', '2025-02-02 10:30:00'),
('USER0006', 'CU002', 'LES00004', 'started', '2025-05-11 15:00:00'),
('USER0006', 'CU002', 'LES00009', 'completed', '2025-02-06 11:00:00'),
('USER0007', 'CU005', 'LES00013', 'started', '2025-02-08 12:00:00'),
('USER0007', 'CU005', 'LES00014', 'completed', '2025-12-08 12:00:00'),
('USER0008', 'CU001', 'LES00003', 'started', '2025-02-11 15:00:00'),
('USER0009', 'CU004', 'LES00011', 'completed', '2025-02-16 19:00:00'),
('USER0010', 'CU005', 'LES00013', 'started', '2025-02-16 16:00:00');
GO 

select * from lms.users;

select * from lms.course;

select * from lms.lesson;

select * from lms.enrollment;

select * from lms.assessment;

select * from lms.assessment_submit;

select * from lms.user_activity;




