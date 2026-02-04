/*
Section 5: Transactions and Concurrency
1. Design a transaction flow for enrolling a user into a course.
2. Explain how to handle concurrent assessment submissions safely.
3. Describe how partial failures should be handled during assessment submission.
4. Recommend suitable transaction isolation levels for enrollments and submissions.
5. Explain how phantom reads could affect analytics queries and how to prevent them.
*/

-- Transactions and Concurrency SQL Queries
USE lms_db;
GO

/*-------------------------------------------------------------------------------------
 1. Design a transaction flow for enrolling a user into a course.
----------------------------------------------------------------------------------------*/
BEGIN TRANSACTION;
    DECLARE @user_id CHAR(9) = 'USER00020';
    DECLARE @course_id CHAR(8) = 'CU001'; 
    BEGIN TRY
        INSERT INTO lms.enrollment (user_id, course_id, enrollment_date, enrollment_status)
        VALUES (@user_id, @course_id, GETDATE(), 'ACTIVE');

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW 50002, 'Enrollment failed. Transaction rolled back.', 1;
    END CATCH;
GO

/*----------------------------------------------------------------------------------------
 2. Explain how to handle concurrent assessment submissions safely.
------------------------------------------------------------------------------------------*/
-- Use SERIALIZABLE isolation level to prevent concurrent submissions
-- Example transaction for submitting an assessment

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION
    DECLARE @user_id CHAR = 'USER00003';
    DECLARE @assessment_id INT = 201;
    BEGIN TRY
        INSERT INTO lms.assessment_submit (user_id, assessment_id, submission_date, obtained_marks)
        VALUES (@user_id, @assessment_id, GETDATE(), 85);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW 50003, 'Assessment submission failed. Transaction rolled back.', 1;
    END CATCH;
GO

/*-----------------------------------------------------------------------------------------------------
 3. Describe how partial failures should be handled during assessment submission.
-------------------------------------------------------------------------------------------------------*/
-- Partial failures in assessment submission should be handled by ensuring atomicity of the transaction.
-- If any part of the submission fails, the entire transaction should be rolled back.
-- This prevents inconsistent data states and ensures data integrity.

/*-------------------------------------------------------------------------------------------------------
 4. Recommend suitable transaction isolation levels for enrollments and submissions.
---------------------------------------------------------------------------------------------------------*/
-- * For enrollments, READ COMMITTED isolation level is suitable to allow concurrent reads 
--    while preventing dirty reads.
-- * For assessment submissions, SERIALIZABLE isolation level is recommended to prevent concurrent 
--    submissions and ensure data integrity.


/*--------------------------------------------------------------------------------------------------------
 5. Explain how phantom reads could affect analytics queries and how to prevent them.
----------------------------------------------------------------------------------------------------------*/
-- * Phantom reads occur when a transaction re-executes a query and gets different results 
--      due to another transaction inserting or deleting rows.
-- * This can affect analytics queries that rely on consistent data sets.
-- * To prevent phantom reads, use SERIALIZABLE isolation level or appropriate locking mechanisms.
-- Example of setting SERIALIZABLE isolation level for analytics query

-- Isolation Level	    Lock Type
-- READ COMMITTED	    Row locks
-- REPEATABLE READ	    Row + shared locks
-- SERIALIZABLE         Key-range locks
-- TABLOCK hint	        Table lock
