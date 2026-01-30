-- Advanced SQL and Analytics

USE lms_db;

/*
11 For each course, calculate:
	Total number of enrolled users
	Total number of lessons
	Average lesson duration
*/
SELECT c.course_id,
	e.total_enrollments AS total_enrollments,
	l.avg_duration AS avg_duration
FROM lms.course c
INNER JOIN (
	SELECT course_id, COUNT(*) AS total_enrollments
	FROM lms.enrollment
	GROUP BY course_id ) e
ON c.course_id = e.course_id
INNER JOIN (
	SELECT lms.course_id,
		COUNT(*) AS total_lessons,
		CAST(
			DATEADD(SECOND,
					AVG(DATEDIFF(SECOND, '00:00:00', duration)),
					'00:00:00'
					)
			AS TIME(0)
			)
			AS avg_duration
	FROM lms.lesson
	GROUP BY course_id ) l
ON c.course_id = l.course_id;
GO


-- 12 Identify the top three most active users based on total activity count

SELECT TOP(3) user_id, COUNT(*) AS total_activity
FROM lms.user_activity
GROUP BY user_id
ORDER BY COUNT(*) DESC;
GO


-- 13 Calculate course completion percentage per user based on lesson activity

SELECT
    u.user_id,
    u.name,
    c.course_id,
    COUNT(DISTINCT l.lesson_id) AS total_lessons,
    COUNT(DISTINCT ua.lesson_id) AS lessons_completed,
    CASE
        WHEN COUNT(DISTINCT l.lesson_id) = 0 THEN 0
        ELSE
            (COUNT(DISTINCT ua.lesson_id) * 100.0) / NULLIF(COUNT(DISTINCT l.lesson_id), 0)    
    END AS completion_percentage
FROM lms.enrollment AS e
JOIN lms.users AS u
    ON u.user_id = e.user_id    
JOIN lms.course AS c
    ON c.course_id = e.course_id    
LEFT JOIN lms.lesson AS l
    ON l.course_id = c.course_id    
LEFT JOIN lms.user_Activity AS ua
    ON ua.user_id = u.user_id
    AND ua.lesson_id = l.lesson_id
GROUP BY
	u.user_id,
    u.name,
    c.course_id
ORDER BY c.course_id DESC;
GO


-- 14 Find users whose average assessment score is higher than the course average

WITH course_average AS (
	SELECT c.course_id, AVG(ass.obtained_marks) AS course_avg_score
	FROM lms.course AS c
	INNER JOIN lms.assessment AS a
		ON c.course_id = a.course_id
	INNER JOIN lms.assessment_submit AS ass
		ON a.assessment_id = ass.assessment_id
	GROUP BY c.course_id
),
user_avg AS (
	SELECT ass.user_id, a.course_id, AVG(ass.obtained_marks) AS avg_score
	FROM lms.assessment AS a
	INNER JOIN lms.assessment_submit AS ass
		ON a.assessment_id = ass.assessment_id
	GROUP BY ass.user_id, a.course_id
)
SELECT ua.user_id, ua.avg_score AS user_avg_score, ca.course_avg_score AS course_avg_score
FROM course_average AS ca
INNER JOIN user_avg AS ua
	ON ca.course_id = ua.course_id
WHERE ua.avg_score > ca.course_avg_score;
GO


-- 15 List courses where lessons are frequently accessed but assessments are never attempted

WITH course_lesson AS (
	SELECT DISTINCT course_id
	FROM lms.user_activity
	WHERE activity_status = 'completed'
),
course_assessment AS (
SELECT cl.course_id, a.assessment_id 
FROM course_lesson AS cl
INNER JOIN lms.assessment AS a
	ON cl.course_id = a.course_id
)
SELECT ca.course_id
FROM course_assessment AS ca
LEFT JOIN lms.assessment_submit AS ass
	ON ca.assessment_id = ass.assessment_id
WHERE ass.assessment_id IS NULL;
GO


-- 16 Rank users within each course based on their total assessment score

SELECT c.course_id, 
	   ass.user_id, 
	   SUM(ass.obtained_marks) AS total_course_score, 
	   DENSE_RANK() 
			OVER( PARTITION BY c.course_id
					ORDER BY SUM(ass.obtained_marks) DESC
				) AS user_rank
FROM lms.course AS c
INNER JOIN lms.assessment AS a
	ON c.course_id = a.course_id
INNER JOIN lms.assessment_submit AS ass
	ON a.assessment_id = ass.assessment_id
GROUP BY c.course_id, ass.user_id;
GO


-- 17 Identify the first lesson accessed by each user for every course

SELECT ua.user_id, l.course_id, l.lesson_id
FROM lms.lesson AS l
INNER JOIN lms.user_activity AS ua 
	ON l.lesson_id = ua.lesson_id
WHERE l.lesson_order = 1;
GO


-- 18 Find users with activity recorded on at least five consecutive days

WITH user_days AS (
    SELECT 
        user_id,
        CAST(activity_date AS DATE) AS activity_day
    FROM lms.user_activity
    GROUP BY user_id, CAST(activity_date AS DATE)
),
consecutive_groups AS (
    SELECT 
        user_id,
        activity_day,
        DATEADD(DAY, -ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY activity_day), activity_day) AS grp
    FROM user_days
)
SELECT DISTINCT user_id
FROM consecutive_groups
GROUP BY user_id, grp
HAVING COUNT(*) >= 5;
GO


-- 19 Retrieve users who enrolled in a course but never submitted any assessment

SELECT e.user_id, e.course_id
FROM lms.enrollment AS e
LEFT JOIN lms.assessment AS a
	ON e.course_id = a.course_id
LEFT JOIN lms.assessment_submit AS ass
	ON a.assessment_id = ass.assessment_id
	AND e.user_id = ass.user_id
WHERE ass.assessment_id IS NULL;
GO


-- 20 List courses where every enrolled user has submitted at least one assessment

SELECT c.course_id
FROM lms.course AS c
WHERE EXISTS (
    -- course must have at least 1 enrollment
    SELECT 1
    FROM lms.enrollment AS e
    WHERE e.course_id = c.course_id
)
AND NOT EXISTS (
    -- find any enrolled user who does not submited assessment
    SELECT 1
    FROM lms.enrollment AS e
    WHERE e.course_id = c.course_id
      AND NOT EXISTS (
          SELECT 1
          FROM lms.assessment AS a
          INNER JOIN lms.assessment_submit AS ass
              ON a.assessment_id = ass.assessment_id
          WHERE a.course_id = c.course_id
            AND ass.user_id = e.user_id
      )
);
GO


									
