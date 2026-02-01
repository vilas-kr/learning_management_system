USE lms_db;
GO

/*
 1 List all users who are enrolled in more than three courses
    why : Inner Join to secelct only the enrolled users
    assumption : users enrolled in some courses
    behaviour : group the users by the user id and count the number of courses they are enrolled in
 */
SELECT users.user_id, COUNT(*) AS total_courses
FROM lms.users 
INNER JOIN lms.enrollment
ON users.user_id = enrollment.user_id
GROUP BY users.user_id
HAVING COUNT(*) > 3;
GO

/*
2 Find courses that currently have no enrollments
    why : To identify courses that are not currently enrolled by any user
    assumption : There are courses in the database that may not have any enrollments
    behaviour : Select course_id from course table where there is no matching enrollment records
*/
SELECT c.course_id
FROM lms.course AS c
LEFT JOIN lms.enrollment AS e
ON c.course_id = e.course_id
WHERE e.course_id IS NULL;
GO

/*
3 Display each course along with the total number of enrolled users
    why : To get enrollment statistics for each course
    assumption : Some courses may have zero enrollments
    behaviour : Left join course with enrollment and group by course_id to count enrollments
*/
SELECT c.course_id, COUNT(e.user_id) AS total_enrollments
FROM lms.course AS c
LEFT JOIN lms.enrollment AS e
ON c.course_id = e.course_id
GROUP BY c.course_id;
GO

/*
 4 Identify users who enrolled in a course but never accessed any lesson
    why : Inner join to select only enrolled users
    assumption : Users may enroll in courses but not access any lessons
    behaviour : For each enrolled user, check if there are no corresponding user activity records for lessons in that course
 */
SELECT 
    e.user_id,
    e.course_id
FROM lms.enrollment e
WHERE NOT EXISTS (
    SELECT 1
    FROM lms.lesson l
    INNER JOIN lms.user_activity ua
        ON ua.lesson_id = l.lesson_id
       AND ua.user_id = e.user_id
    WHERE l.course_id = e.course_id
);
GO

/*
 5 Fetch lessons that have never been accessed by any user
    why : Lessons may exist that no user has accessed
    assumption : There are lessons in the database that may not have any user activity records
    behaviour : Left join lessons with user activity and filter where there is no matching user activity records
*/
SELECT l.lesson_id
FROM lms.lesson AS l
LEFT JOIN lms.user_activity AS ua
ON l.lesson_id = ua.lesson_id
WHERE ua.lesson_id IS NULL;
GO

/*
 6 Show the last activity timestamp for each user.
    why : To track each user's most recent activity
    assumption : Some users may not have any activity records
    behaviour : Left join users with user activity and group by user_id to get the maximum activity date
*/
SELECT u.user_id, MAX(ua.activity_date)
FROM lms.users AS u
LEFT JOIN lms.user_activity AS ua
ON u.user_id = ua.user_id
GROUP BY u.user_id;
GO

/*
 7 List users who submitted an assessment but scored less than 50 percent of the maximum score
    why : To identify only the submissions with low scores
    assumption : There are assessment submissions with scores below 50 percent
    behaviour : Join assessment submissions with assessments to calculate percentage scores and filter those below 50 percent
*/
SELECT ass.user_id, ass.assessment_id, ((CAST(ass.obtained_marks AS FLOAT)/CAST(a.max_score AS FLOAT)) * 100) AS percentage
FROM lms.assessment_submit AS ass
INNER JOIN lms.assessment AS a
ON ass.assessment_id = a.assessment_id 
WHERE (CAST(ass.obtained_marks AS FLOAT)/CAST(a.max_score AS FLOAT) * 100) < 50;
GO

/*
 8 Find assessments that have not received any submissions.
    why : To identify assessments that have no submissions
    assumption : There are assessments in the database that may not have any submissions
    behaviour : Left join assessment with assessment_submit and filter where there is no matching submission records
*/
SELECT a.assessment_id, a.assessment_name
FROM lms.assessment AS a
LEFT JOIN lms.assessment_submit AS ass
ON a.assessment_id = ass.assessment_id
WHERE ass.assessment_id IS NULL;
GO

/*
 9 Display the highest score achieved for each assessment
    why : Left join to get all assessments and their highest scores
    assumption : Some assessments may not have any submissions
    behaviour : Left join assessment with assessment_submit and group by assessment_id and assessment_name to get 
        the maximum obtained marks for each assessment
*/
SELECT a.assessment_id, a.assessment_name, MAX(ass.obtained_marks) AS highest_score
FROM lms.assessment AS a
LEFT JOIN lms.assessment_submit AS ass
ON a.assessment_id = ass.assessment_id
GROUP BY a.assessment_id, a.assessment_name;
GO

/*
 10 Identify users who are enrolled in a course but have an inactive enrollment status
    why : To identify only the enrolled students
    assumption : There are users enrolled in courses with inactive enrollment status
    behaviour : Filter enrollment records where enrollment_status is 'INACTIVE'
*/
SELECT user_id, course_id, enrollment_status
FROM lms.enrollment
WHERE enrollment_status = 'INACTIVE';
GO
