USE lms_db;
GO

-- 1 List all users who are enrolled in more than three courses
SELECT users.user_id, COUNT(*) AS total_courses
FROM lms.users 
INNER JOIN lms.enrollment
ON users.user_id = enrollment.user_id
GROUP BY users.user_id
HAVING COUNT(*) > 3;
GO

-- 2 Find courses that currently have no enrollments
SELECT c.course_id
FROM lms.course AS c
LEFT JOIN lms.enrollment AS e
ON c.course_id = e.course_id
WHERE e.course_id IS NULL;
GO

-- 3 Display each course along with the total number of enrolled users
SELECT c.course_id, COUNT(e.user_id) AS total_enrollments
FROM lms.course AS c
LEFT JOIN lms.enrollment AS e
ON c.course_id = e.course_id
GROUP BY c.course_id;
GO

-- 4 Identify users who enrolled in a course but never accessed any lesson
SELECT 
    e.user_id,
    e.course_id
FROM lms.enrollment e
WHERE NOT EXISTS (
    SELECT 1
    FROM lms.lesson l
    JOIN lms.user_activity ua
        ON ua.lesson_id = l.lesson_id
       AND ua.user_id = e.user_id
    WHERE l.course_id = e.course_id
);
GO

-- 5 Fetch lessons that have never been accessed by any user
SELECT l.lesson_id
FROM lms.lesson AS l
LEFT JOIN lms.user_activity AS ua
ON l.lesson_id = ua.lesson_id
WHERE ua.lesson_id IS NULL;
GO

-- 6 Show the last activity timestamp for each user.
SELECT u.user_id, MAX(ua.activity_date)
FROM lms.users AS u
LEFT JOIN lms.user_activity AS ua
ON u.user_id = ua.user_id
GROUP BY u.user_id;
GO

-- 7 List users who submitted an assessment but scored less than 50 percent of the maximum score
SELECT ass.user_id, ass.assessment_id, ((CAST(ass.obtained_marks AS FLOAT)/CAST(a.max_score AS FLOAT)) * 100) AS percentage
FROM lms.assessment_submit AS ass
INNER JOIN lms.assessment AS a
ON ass.assessment_id = a.assessment_id 
WHERE (CAST(ass.obtained_marks AS FLOAT)/CAST(a.max_score AS FLOAT) * 100) < 50;
GO

-- 8 Find assessments that have not received any submissions.
SELECT a.assessment_id, a.assessment_name
FROM lms.assessment AS a
LEFT JOIN lms.assessment_submit AS ass
ON a.assessment_id = ass.assessment_id
WHERE ass.assessment_id IS NULL;
GO

-- 9 Display the highest score achieved for each assessment
SELECT a.assessment_id, a.assessment_name, MAX(ass.obtained_marks) AS highest_score
FROM lms.assessment AS a
LEFT JOIN lms.assessment_submit AS ass
ON a.assessment_id = ass.assessment_id
GROUP BY a.assessment_id, a.assessment_name;
GO

-- 10 Identify users who are enrolled in a course but have an inactive enrollment status
SELECT user_id, course_id, enrollment_status
FROM lms.enrollment
WHERE enrollment_status = 'INACTIVE';
GO
