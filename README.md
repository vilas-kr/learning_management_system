# Learning Management System (LMS)
This Learning Management System (LMS) database schema implemented using TSQL. The schema includes tables for users, courses, enrollments, assessments, assessment submissions, and user activity logs

## Project Overview
The Learning Management System (LMS) is designed to facilitate the management and delivery of educational courses and training programs. This system allows instructors to create and manage courses, assessments, and track student progress, while students can enroll in courses, complete assessments, and monitor their learning activities.

1. Users manage their profiles and roles (students, instructors).
2. Instructors create and manage courses and assessments.
3. Students enroll in courses and complete assessments.
4. The system tracks user activity and assessment submissions for reporting and analytics.

## Schema and Arhitecture
### 1. Tables and Relationships:

| Table Name               | Description                                      |
|--------------------------|--------------------------------------------------|
|Users | Stores user information including roles (student, instructor)|
|Courses | Contains course details|
|Enrollments | Links students to the courses they are enrolled in |
|Assessments | Holds information about assessments associated with courses |
|Assessment Submissions | Records student submissions for assessments |
|User Activity | Tracks user activities within the LMS |

### 2. Key Relationships:
1. Users enroll in courses (Enrollments)
2. Courses contain lessons and assessments(Lessons, Assessments)
3. Users interact with lessons (User_Activity)
4. Users submit assessments (Assessment_Submission)

## Author
Vilas K R
GitHub Username : vilas-kr

