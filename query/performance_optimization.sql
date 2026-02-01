/*
Section 3: Performance and Optimization
1 Suggest appropriate indexes for improving performance of:
    Course dashboards
    User activity analytics

2 Identify potential performance bottlenecks in queries involving user activity.
3 Explain how you would optimize queries when the user_activity table grows to millions of rows.
4 Describe scenarios where materialized views would be useful for this schema.
5 Explain how partitioning could be applied to user_activity.
*/

-- Performance Optimization SQL Queries
USE lms_db;
GO

/*
 1 Suggest appropriate indexes for improving performance of:
    Course dashboards
    User activity analytics
*/
-- Index for Course Dashboards
CREATE INDEX idx_course_id ON lms.course(course_id);
CREATE INDEX idx_enrollment_course_id ON lms.enrollment(course_id);
CREATE INDEX idx_lesson_course_id ON lms.lesson(course_id);
CREATE INDEX idx_user_activity_user_id ON lms.user_activity(user_id);
GO

/*
 2 Identify potential performance bottlenecks in queries involving user activity.
*/
-- Analyze Query Execution Plans
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

-- Example query
SELECT ua.user_id, COUNT(*) AS activity_count   
FROM lms.user_activity ua
GROUP BY ua.user_id
ORDER BY activity_count DESC;
SET STATISTICS IO OFF;  
SET STATISTICS TIME OFF;
GO

/*
 3 Explain how you would optimize queries when the user_activity table grows to millions of rows.
*/
-- Optimization Strategies
-- 1. Implement indexing on frequently queried columns (e.g user_id, activity_status)
-- 2. Use partitioning on user_activity table based on date ranges to improve query performance
-- 3. Optimize queries to avoid SELECT * and only retrieve necessary columns


/*
 4 Describe scenarios where materialized views would be useful for this schema.
*/
-- Materialized views would be useful in scenarios such as: 
-- 1. Pre-aggregated user activity statistics for dashboards to reduce computation time
-- 2. Course completion rates per user to quickly retrieve progress without recalculating
-- 3. Frequently accessed reports on enrollment trends over time
-- 4. Pre-aggregated assessment scores per course for quick analytics


/*
 5 Explain how partitioning could be applied to user_activity.
*/
-- Partitioning Strategy
-- 1. Range Partitioning: Partition user_activity table by activity_date into monthly or yearly partitions
-- 2. This allows queries filtering by date to only scan relevant partitions, improving performance
-- 3. Example: Create partition function and scheme for user_activity table based on activity_date

