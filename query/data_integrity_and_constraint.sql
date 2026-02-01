/*
Section 4: Data Integrity and Constraints
1 Propose constraints to ensure a user cannot submit the same assessment more than once.
2 Ensure that assessment scores do not exceed the defined maximum score.
3 Prevent users from enrolling in courses that have no lessons.
4 Ensure that only instructors can create courses.
5 Describe a safe strategy for deleting courses while preserving historical data.
*/

-- Data Integrity and Constraints SQL Queries
USE lms_db;
GO

/*
 1 Propose constraints to ensure a user cannot submit the same assessment more than once.
*/
ALTER TABLE lms.assessment_submit
ADD CONSTRAINT uq_user_assessment_submit UNIQUE (user_id, assessment_id);
GO

/*
 2 Ensure that assessment scores do not exceed the defined maximum score.
*/
ALTER TABLE lms.assessment_submit
ADD CONSTRAINT chk_obtained_marks CHECK 
    (obtained_marks <= 
        (SELECT max_score 
        FROM lms.assessment 
        WHERE assessment.assessment_id = assessment_submit.assessment_id
        )
    );
GO  

/*
 3 Prevent users from enrolling in courses that have no lessons.
*/
CREATE TRIGGER trg_prevent_enrollment_no_lessons
ON lms.enrollment
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        LEFT JOIN lms.lesson l ON i.course_id = l.course_id
        WHERE l.course_id IS NULL
    )
    BEGIN
        THROW 50001, 'Cannot enroll in a course with no lessons.', 1;
    END
    ELSE
    BEGIN
        INSERT INTO lms.enrollment (user_id, course_id, enrollment_date, enrollment_status)
        SELECT user_id, course_id, GETDATE(), 'ACTIVE'
        FROM inserted;
    END
END;
GO

/*
 4 Ensure that only instructors can create courses.
*/

-- Add role column to users table if not exists
ALTER TABLE lms.users
ADD user_role VARCHAR(20) DEFAULT 'STUDENT';
GO

ALTER TABLE lms.users
ADD CONSTRAINT ck_user_role CHECK (user_role IN ('STUDENT', 'INSTRUCTOR'));
GO

-- define trigger to enforce only instructors can create courses
CREATE TRIGGER trg_only_instructors_create_course
ON lms.course
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        LEFT JOIN lms.users u ON i.created_by = u.user_id
        WHERE u.role <> 'INSTRUCTOR'
    )
    BEGIN
        THROW 50002, 'Only instructors can create courses', 1;
    END
    ELSE
    BEGIN
        INSERT INTO lms.course (course_id, course_name, course_title)
        SELECT course_id, course_name, course_title
        FROM inserted;
    END
END;
GO

/*
 5 Describe a safe strategy for deleting courses while preserving historical data.
*/
-- Strategy: Use soft delete by adding an 'available' flag to the course table
-- This way, courses can be marked as inactive instead of being physically deleted
-- preserving historical data for reporting and analytics
ALTER TABLE lms.course
ADD available BIT DEFAULT 1;
GO


