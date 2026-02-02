/*
Section 6: Database Design and Architecture
1. Propose schema changes to support course completion certificates.
2. Describe how you would track video progress efficiently at scale.
3. Discuss normalization versus denormalization trade-offs for user activity data.
4. Design a reporting-friendly schema for analytics dashboards.
5. Explain how this schema should evolve to support millions of users.
*/

-- Database Design and Architecture SQL Queries

USE lms_db;
GO

/*------------------------------------------------------------------------------------------
 1. Propose schema changes to support course completion certificates.
    
    Behaviour: Create a new table 'certificate' to store course completion certificates.
--------------------------------------------------------------------------------------------*/
CREATE TABLE lms.certificate (
    certificate_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    issue_date DATETIME NOT NULL DEFAULT GETDATE(),
    UNIQUE (user_id, course_id),
    FOREIGN KEY (user_id) REFERENCES lms.users(user_id),
    FOREIGN KEY (course_id) REFERENCES lms.course(course_id)
);
GO

/*-------------------------------------------------------------------------------------------
 2. Describe how you would track video progress efficiently at scale.
---------------------------------------------------------------------------------------------*/
-- * Create a new table 'video_progress' to track user video progress
-- * Use indexing on user_id and video_id for efficient querying
-- * Store only necessary data to minimize storage requirements
GO

/*-------------------------------------------------------------------------------------------
 3. Discuss normalization versus denormalization trade-offs for user activity data.
 --------------------------------------------------------------------------------------------*/

-- Normalized user activity table
/*---------------------------------
    Normalized user activity table
        user_id from lms.users
        lesson_id from lms.lesson
    
    This is in 3NF there is no transitive dependency
    1. Ensures data integrity and reduces redundancy
    2. Easier to maintain consistency
    3. More complex queries due to joins
*/

-- Denormalized user activity table
/* ---------------------------------
    Denormalized user activity table
        user_id from lms.users
        user_name from lms.users
        lesson_id from lms.lesson
        course_id from lms.course
        course_name from lms.course
   
    This is in 2NF but not in 3NF due to transitive dependency on course_id, user_name, course_name
    1. Faster read performance for analytics queries
    2. Simpler queries without joins
    3. Increased storage requirements and potential data anomalies
    4. Challenging to maintain data consistency
    5. Suitable for read-heavy workloads where performance is critical
    6. Requires careful management of data updates to avoid inconsistencies
*/

/*--------------------------------------------------------------------------------------------------
 4. Design a reporting-friendly schema for analytics dashboards.
----------------------------------------------------------------------------------------------------*/
CREATE TABLE lms.analytics_user_course_summary (
    user_id CHAR(9) NOT NULL,
    course_id CHAR(5) NOT NULL,
    total_lessons_completed INT NOT NULL,
    total_assessments_taken INT NOT NULL,
    average_score FLOAT NOT NULL,
    last_activity_date DATETIME NOT NULL,
    PRIMARY KEY (user_id, course_id),
    FOREIGN KEY (user_id) REFERENCES lms.users(user_id),
    FOREIGN KEY (course_id) REFERENCES lms.course(course_id)
);
GO

/*---------------------------------------------------------------------------------------------------
 5. Explain how this schema should evolve to support millions of users.
-----------------------------------------------------------------------------------------------------*/
-- To support millions of users, consider the following strategies:
-- 1. Partition large tables e.g user activity tables based on user_id or course_id to improve query performance.
-- 2. Implement indexing strategies on frequently queried columns to speed up data retrieval.
-- 3. Use caching mechanisms for frequently accessed data to reduce database load.
-- 4. Regularly archive historical data to separate storage to keep the main tables lean.
-- 5. Monitor database performance and scale resources e.g., read replicas, sharding as needed to handle increased load.
-- 6. Optimize queries and use materialized views for complex analytics to improve response times.




