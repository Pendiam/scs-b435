/*
 * Online Learning Platform - Sample Data
 * ====================================
 * 
 * This script populates the database with realistic test data that demonstrates:
 * 1. How triggers automatically track progress when videos are watched
 * 2. How functions calculate completion percentages
 * 3. How constraints enforce data integrity
 * 4. Multiple student scenarios (partial, in-progress, completed)
 * 
 * Data Validation:
 * - Dates updated to 2026 (current academic year)
 * - VideoWatch table populated to demonstrate video tracking triggers
 * - Progress data initialized (later updated by triggers)
 * - Multiple enrollment/completion scenarios for testing
 * - Diverse course content with varying difficulty levels
 * 
 * Testing Scenarios Created:
 * 1. Alice: Highly engaged (completed both courses, started advanced)
 * 2. Bob: Moderate engagement (completed intro, not started advanced)
 * 3. Charlie: Expert instructor (teaching multiple courses)
 * 4. Diana: New student (just enrolled, no progress yet)
 */

-- ============================================================================
-- Users: 4 users with different roles
-- ============================================================================

INSERT INTO Users (username, email, password_hash, role) VALUES
('alice_johnson', 'alice@university.edu', 'hashed_password_alice_2024', 'student'),
('bob_smith', 'bob@university.edu', 'hashed_password_bob_2024', 'student'),
('charlie_mentor', 'charlie.instructor@university.edu', 'hashed_password_charlie_2024', 'instructor'),
('diana_fresh', 'diana.new@university.edu', 'hashed_password_diana_2024', 'student'),
('admin_user', 'admin@university.edu', 'hashed_password_admin_2024', 'admin');

-- ============================================================================
-- Courses: 4 diverse courses representing different levels
-- ============================================================================

INSERT INTO Courses (title, description, instructor_id) VALUES
('Introduction to SQL', 'Learn fundamental SQL queries, SELECT statements, and basic database concepts.', 3),
('Advanced PostgreSQL', 'Master advanced PostgreSQL features: indexing, partitioning, triggers, and functions.', 3),
('Database Design Fundamentals', 'Learn normalization, schema design, and relational algebra principles.', 3),
('Data Science with SQL', 'Apply SQL for data exploration, aggregation, and analytics in real-world scenarios.', 3);

-- ============================================================================
-- Enrollments: Students enrolled in various courses
-- ============================================================================

INSERT INTO Enrollments (user_id, course_id, enrolled_at) VALUES
-- Alice: Enrolled in 3 courses (highly engaged student)
(1, 1, '2026-01-15 10:00:00'),   -- Intro to SQL
(1, 2, '2026-02-01 14:30:00'),   -- Advanced PostgreSQL
(1, 4, '2026-03-10 09:15:00'),   -- Data Science with SQL
-- Bob: Enrolled in 2 courses (moderate engagement)
(2, 1, '2026-01-20 11:00:00'),   -- Intro to SQL
(2, 3, '2026-02-15 16:45:00'),   -- Database Design
-- Diana: Enrolled in 1 course (new student)
(4, 1, '2026-04-01 13:20:00');   -- Intro to SQL

-- ============================================================================
-- Modules: Course structure with learning sequence
-- ============================================================================

INSERT INTO Modules (course_id, title, description, order_number) VALUES
-- Course 1: Intro to SQL (4 modules)
(1, 'SQL Basics and Syntax', 'Learn SELECT, WHERE, ORDER BY fundamentals.', 1),
(1, 'Joins and Relationships', 'INNER JOIN, LEFT JOIN, UNION operations.', 2),
(1, 'Aggregation and Grouping', 'GROUP BY, HAVING, aggregate functions.', 3),
(1, 'Subqueries and CTEs', 'Common Table Expressions and nested queries.', 4),
-- Course 2: Advanced PostgreSQL (3 modules)
(2, 'Indexing Strategies', 'B-tree, Hash, GiST indexes for performance.', 1),
(2, 'Table Partitioning', 'Range, list, and hash partitioning techniques.', 2),
(2, 'Triggers and Functions', 'Automation with PL/pgSQL triggers.', 3),
-- Course 3: Database Design (3 modules)
(3, 'Normalization Principles', '1NF, 2NF, 3NF, BCNF normalization forms.', 1),
(3, 'Entity Relationship Modeling', 'ER diagrams, cardinality, constraints.', 2),
(3, 'Advanced Schema Design', 'Inheritance, partitioning strategies.', 3),
-- Course 4: Data Science with SQL (3 modules)
(4, 'Data Exploration Techniques', 'SELECT patterns for EDA.', 1),
(4, 'Statistical Functions', 'AVG, STDDEV, PERCENTILE functions.', 2),
(4, 'Time Series Analysis', 'Window functions, lag, lead operations.', 3);

-- ============================================================================
-- Videos: Course content
-- ============================================================================

INSERT INTO Videos (module_id, title, url, duration) VALUES
-- Module 1: SQL Basics (3 videos)
(1, 'Introduction to SELECT', 'https://courses.example.com/sql/intro-select', 420),
(1, 'WHERE Clause Tutorial', 'https://courses.example.com/sql/where-clause', 320),
(1, 'ORDER BY and LIMIT', 'https://courses.example.com/sql/order-limit', 280),
-- Module 2: Joins (4 videos)
(2, 'INNER JOIN Explained', 'https://courses.example.com/sql/inner-join', 480),
(2, 'LEFT JOIN Tutorial', 'https://courses.example.com/sql/left-join', 420),
(2, 'UNION and Set Operations', 'https://courses.example.com/sql/union', 360),
(2, 'Complex Joins Exercise', 'https://courses.example.com/sql/complex-joins', 540),
-- Module 3: Aggregation (3 videos)
(3, 'GROUP BY Fundamentals', 'https://courses.example.com/sql/group-by', 400),
(3, 'Aggregate Functions (COUNT, SUM, AVG)', 'https://courses.example.com/sql/aggregates', 380),
(3, 'HAVING Clause and Filtering Groups', 'https://courses.example.com/sql/having', 320),
-- Module 4: Subqueries (2 videos)
(4, 'Scalar and Correlated Subqueries', 'https://courses.example.com/sql/subqueries', 520),
(4, 'Common Table Expressions (WITH Clause)', 'https://courses.example.com/sql/cte', 460),
-- Advanced PostgreSQL Videos
(5, 'Creating and Maintaining Indexes', 'https://courses.example.com/postgres/indexes', 580),
(6, 'Implementing Table Partitioning', 'https://courses.example.com/postgres/partitioning', 620),
(7, 'Writing PL/pgSQL Triggers', 'https://courses.example.com/postgres/triggers', 700);

-- ============================================================================
-- VideoWatch: Tracks when students watch videos (for trigger testing)
-- ============================================================================

-- Alice's video watches (comprehensive progress)
INSERT INTO VideoWatch (user_id, video_id, module_id, watched_at) VALUES
(1, 1, 1, '2026-01-16 10:30:00'),
(1, 2, 1, '2026-01-17 14:00:00'),
(1, 3, 1, '2026-01-18 09:45:00'),
(1, 4, 2, '2026-01-20 11:20:00'),
(1, 5, 2, '2026-01-21 15:30:00'),
(1, 6, 2, '2026-01-22 10:45:00'),
(1, 7, 2, '2026-01-23 13:15:00'),
(1, 8, 3, '2026-01-25 09:50:00'),
(1, 9, 3, '2026-01-26 14:20:00'),
(1, 10, 4, '2026-01-28 11:35:00'),
(1, 12, 5, '2026-02-05 10:00:00'),
(1, 13, 6, '2026-02-10 14:30:00'),
-- Bob's video watches (moderate progress - just finished intro)
(2, 1, 1, '2026-01-21 09:00:00'),
(2, 2, 1, '2026-01-22 10:15:00'),
(2, 3, 1, '2026-01-23 15:45:00'),
(2, 4, 2, '2026-01-25 11:30:00'),
(2, 5, 2, '2026-01-26 14:00:00'),
-- Diana's video watches (barely started - new student)
(4, 1, 1, '2026-04-02 13:00:00');

-- ============================================================================
-- Assignments: Assessment for each module
-- ============================================================================

INSERT INTO Assignments (module_id, title, details, due_date) VALUES
-- Module 1
(1, 'Write Your First SELECT', '{"instructions":"Write a query to retrieve all data from users table.", "difficulty":"easy"}', '2026-01-25 23:59:59'),
-- Module 2
(2, 'Master INNER JOIN', '{"instructions":"Join users with their enrollments.", "difficulty":"medium"}', '2026-02-01 23:59:59'),
-- Module 3
(3, 'Aggregation Challenge', '{"instructions":"Group results and compute statistics.", "difficulty":"medium"}', '2026-02-08 23:59:59'),
-- Module 4
(4, 'Complex Subquery Project', '{"instructions":"Write nested queries and CTEs.", "difficulty":"hard"}', '2026-02-15 23:59:59'),
-- Module 5
(5, 'Index Creation Exercise', '{"instructions":"Design and create appropriate indexes.", "difficulty":"hard"}', '2026-02-20 23:59:59'),
-- Module 6
(6, 'Partitioning Simulation', '{"instructions":"Partition data for performance.", "difficulty":"hard"}', '2026-02-25 23:59:59'),
-- Module 7
(7, 'Build a Trigger System', '{"instructions":"Write triggers for data validation.", "difficulty":"expert"}', '2026-03-05 23:59:59');

-- ============================================================================
-- Submissions: Student assignment submissions with grades
-- ============================================================================

INSERT INTO Submissions (assignment_id, user_id, submitted_at, grade) VALUES
-- Alice's submissions (excellent student)
(1, 1, '2026-01-24 18:30:00', 98.0),
(2, 1, '2026-01-31 20:15:00', 95.0),
(3, 1, '2026-02-07 19:45:00', 92.0),
(4, 1, '2026-02-14 21:30:00', 94.0),
(5, 1, '2026-02-19 17:20:00', 91.0),
(6, 1, '2026-02-24 19:00:00', 89.0),
-- Bob's submissions (good but slower)
(1, 2, '2026-01-25 22:00:00', 87.0),
(2, 2, '2026-02-02 20:30:00', 85.0),
(3, 2, '2026-02-09 21:15:00', 82.0);

-- ============================================================================
-- Progress: Student module progress (initialized data)
-- ============================================================================

-- Note: In production, Progress records are created/updated by triggers
-- These initial values demonstrate expected state after trigger operations

INSERT INTO Progress (user_id, module_id, videos_watched, assignments_completed, last_updated) VALUES
-- Alice: Advanced progress (completed modules in intro, started advanced)
(1, 1, 3, 1, '2026-01-24 18:35:00'),
(1, 2, 4, 1, '2026-01-31 20:20:00'),
(1, 3, 2, 1, '2026-02-07 19:50:00'),
(1, 4, 1, 1, '2026-02-14 21:35:00'),
(1, 5, 1, 1, '2026-02-19 17:25:00'),
(1, 6, 1, 0, '2026-02-10 14:35:00'),
-- Bob: Moderate progress (intro nearly complete, advanced not started)
(2, 1, 3, 1, '2026-01-25 22:05:00'),
(2, 2, 2, 1, '2026-02-02 20:35:00'),
(2, 3, 0, 1, '2026-02-09 21:20:00'),
-- Diana: Just starting
(4, 1, 1, 0, '2026-04-02 13:05:00');

-- ============================================================================
-- Reviews: Student course feedback
-- ============================================================================

INSERT INTO Reviews (user_id, course_id, rating, comment, created_at) VALUES
(1, 1, 5, 'Excellent introduction to SQL! Clear explanations and practical exercises.', '2026-02-01 15:30:00'),
(1, 2, 5, 'Advanced content is challenging but very rewarding. Triggers section was eye-opening.', '2026-03-01 16:00:00'),
(2, 1, 4, 'Good fundamentals course. Wish there were more real-world examples.', '2026-02-05 14:20:00'),
(2, 3, 4, 'Database design principles well explained. A bit theoretical but solid foundation.', '2026-03-10 10:45:00');

-- ============================================================================
-- Payments: Student course purchases (2024 and 2026 for partition testing)
-- ============================================================================

INSERT INTO Payments (user_id, course_id, amount, payment_date) VALUES
-- 2024 payments (historical - partition Payments_2024 if it exists)
(1, 1, 99.99, '2024-01-15 08:30:00'),
(2, 1, 99.99, '2024-01-20 09:15:00'),
-- 2026 payments (current year)
(1, 2, 149.99, '2026-02-01 10:00:00'),
(1, 4, 129.99, '2026-03-10 11:30:00'),
(2, 3, 119.99, '2026-02-15 14:45:00'),
(4, 1, 99.99, '2026-04-01 13:25:00');

-- ============================================================================
-- Verification Queries (Comment out after verification)
-- ============================================================================

-- Verify data counts:
-- SELECT 'Users' AS table_name, COUNT(*) as count FROM Users
-- UNION ALL SELECT 'Courses', COUNT(*) FROM Courses
-- UNION ALL SELECT 'Enrollments', COUNT(*) FROM Enrollments
-- UNION ALL SELECT 'Modules', COUNT(*) FROM Modules
-- UNION ALL SELECT 'Videos', COUNT(*) FROM Videos
-- UNION ALL SELECT 'VideoWatch', COUNT(*) FROM VideoWatch
-- UNION ALL SELECT 'Assignments', COUNT(*) FROM Assignments
-- UNION ALL SELECT 'Submissions', COUNT(*) FROM Submissions
-- UNION ALL SELECT 'Progress', COUNT(*) FROM Progress
-- UNION ALL SELECT 'Reviews', COUNT(*) FROM Reviews
-- UNION ALL SELECT 'Payments', COUNT(*) FROM Payments;

-- Verify Alice's completion: SELECT * FROM Progress WHERE user_id = 1 ORDER BY module_id;
-- Verify triggers work: INSERT INTO VideoWatch (user_id, video_id, module_id) VALUES (1, 11, 4);
--                      SELECT * FROM Progress WHERE user_id = 1 AND module_id = 4;
