/* 
---------------------------------------------------------------------------------------------
The schema represents an LMS with the following entities:
Users, Courses, Lessons, Enrollments, User Activity, Assessments, and Assessment Submissions.

Relationships include:
Users enroll in courses
Courses contain lessons and assessments
Users perform activities on lessons
Users submit assessments and receive scores
----------------------------------------------------------------------------------------------
*/

CREATE DATABASE lms_db;
GO 

USE lms_db;
GO

CREATE SCHEMA lms;
GO

CREATE TABLE lms.users (
	user_id CHAR(9), -- 'USER00001'
	name VARCHAR(50),
	email VARCHAR(256),
	password VARCHAR(50),
	PRIMARY KEY (user_id)
);
GO

ALTER TABLE lms.users
ADD CONSTRAINT unique_email UNIQUE (email);
GO 

CREATE TABLE lms.course (
	course_id CHAR(5), -- 'CU001'
	course_name VARCHAR(100),
	course_title VARCHAR(1000),
	PRIMARY KEY (course_id)
);
GO

ALTER TABLE lms.course
ADD CONSTRAINT unique_course_name UNIQUE (course_name);
GO

CREATE TABLE lms.lesson (
	lesson_id CHAR(8), -- 'LES00001'
	course_id CHAR(5),
	lesson_title VARCHAR(100),
	lesson_order SMALLINT,
	duration TIME(0),
	PRIMARY KEY (lesson_id)
);
GO

ALTER TABLE lms.lesson 
ADD CONSTRAINT uq_course_lesson_order UNIQUE (course_id, lesson_order)
GO

ALTER TABLE lms.lesson 
ADD CONSTRAINT fk_course_lesson FOREIGN KEY (course_id) 
REFERENCES lms.course (course_id);
GO

CREATE TABLE lms.enrollment (
	user_id CHAR(9),
	course_id CHAR(5),
	enrollment_date DATETIME2(0),
	enrollment_status VARCHAR(20),
	PRIMARY KEY (user_id, course_id)
);
GO

ALTER TABLE lms.enrollment 
ADD CONSTRAINT fk_course_enrollment FOREIGN KEY (course_id) 
REFERENCES lms.course (course_id);
GO

ALTER TABLE lms.enrollment 
ADD CONSTRAINT fk_user_enrollment FOREIGN KEY (user_id) 
REFERENCES lms.users (user_id);
GO

ALTER TABLE lms.enrollment
ADD CONSTRAINT ck_enrollment_status CHECK (enrollment_status IN ('ACTIVE', 'INACTIVE'));
GO

CREATE TABLE lms.assessment (
	assessment_id INT IDENTITY(1, 1),
	course_id CHAR(5),
	assessment_name VARCHAR(100),
	max_score SMALLINT NOT NULL,
	PRIMARY KEY (assessment_id)
);
GO

ALTER TABLE lms.assessment 
ADD CONSTRAINT fk_course_assessment FOREIGN KEY (course_id) 
REFERENCES lms.course (course_id);
GO

CREATE TABLE lms.assessment_submit (
	assessment_id INT,
	user_id CHAR(9),
	obtained_marks INT,
	submission_date DATETIME2(0),
	PRIMARY KEY (assessment_id, user_id)
);
GO

ALTER TABLE lms.assessment_submit 
ADD CONSTRAINT fk_user_assessment_submit FOREIGN KEY (user_id) 
REFERENCES lms.users (user_id);
GO 

ALTER TABLE lms.assessment_submit 
ADD CONSTRAINT fk_assessment_assessment_submit FOREIGN KEY (assessment_id) 
REFERENCES lms.assessment (assessment_id);
GO 

ALTER TABLE lms.assessment_submit 
ADD CONSTRAINT df_submission_date DEFAULT GETDATE() FOR submission_date;
GO

CREATE TABLE lms.user_activity (
	user_id CHAR(9),
	course_id CHAR(5),
	lesson_id CHAR(8),
	activity_status VARCHAR(20),
	activity_date DATETIME2(0),
	PRIMARY KEY (user_id, lesson_id, course_id)
);
GO

ALTER TABLE lms.user_activity
ADD CONSTRAINT fk_user_user_activity FOREIGN KEY (user_id) 
REFERENCES lms.users (user_id);
GO

ALTER TABLE lms.user_activity
ADD CONSTRAINT fk_lesson_user_activity FOREIGN KEY (lesson_id)
REFERENCES lms.lesson (lesson_id)
GO

ALTER TABLE lms.user_activity 
ADD CONSTRAINT fk_course_user_activity FOREIGN KEY (course_id) 
REFERENCES lms.course (course_id);
GO

ALTER TABLE lms.user_activity
ADD CONSTRAINT ck_status CHECK (activity_status IN ('STARTED', 'COMPLETED'));
GO

ALTER TABLE lms.user_activity 
ADD CONSTRAINT df_activity_date DEFAULT GETDATE() FOR activity_date;
GO


