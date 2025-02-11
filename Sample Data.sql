--  Users
 INSERT INTO Users (username, email, password_hash, role) VALUES
('alice', 'alice@example.com', 'hashed_password_1', 'student'),
('bob', 'bob@example.com', 'hashed_password_2', 'student'),
('charlie', 'charlie@example.com', 'hashed_password_3', 'instructor'),
('dave', 'dave@example.com', 'hashed_password_4', 'admin');

--  Courses
INSERT INTO Courses (title, description, instructor_id) VALUES
('Introduction to SQL', 'Learn the basics of SQL and database management.', 3),
('Advanced PostgreSQL', 'Master advanced PostgreSQL concepts like indexing, partitioning, and triggers.', 3),
('Data Science Fundamentals', 'A comprehensive course on data science and machine learning.', 3);

-- Enrollments
INSERT INTO Enrollments (user_id, course_id) VALUES
(1, 1), -- Alice enrolled in Introduction to SQL
(2, 1), -- Bob enrolled in Introduction to SQL
(1, 2); -- Alice enrolled in Advanced PostgreSQL

-- Modules
INSERT INTO Modules (course_id, title, description, order_number) VALUES
(1, 'SQL Basics', 'Learn the basics of SQL syntax.', 1),
(1, 'Joins and Subqueries', 'Understand how to join tables and write subqueries.', 2),
(2, 'Indexing in PostgreSQL', 'Learn how to create and optimize indexes.', 1),
(2, 'Partitioning Large Tables', 'Understand table partitioning for performance.', 2);

-- Videos
INSERT INTO Videos (module_id, title, url, duration) VALUES
(1, 'What is SQL?', 'https://example.com/video1', 300),
(1, 'SELECT Statement', 'https://example.com/video2', 450),
(2, 'INNER JOIN Explained', 'https://example.com/video3', 600),
(3, 'Introduction to Indexing', 'https://example.com/video4', 500);

-- Assignments
INSERT INTO Assignments (module_id, title, details, due_date) VALUES
(1, 'Write Your First Query', '{"instructions": "Write a SELECT query to fetch all users."}', '2023-12-01'),
(2, 'Practice Joins', '{"instructions": "Write a query to join two tables."}', '2023-12-15'),
(3, 'Create an Index', '{"instructions": "Create an index on the users table."}', '2023-12-10');

-- Submissions
INSERT INTO Submissions (assignment_id, user_id, grade) VALUES
(1, 1, 95.0), -- Alice's submission for Assignment 1
(1, 2, 85.0), -- Bob's submission for Assignment 1
(2, 1, 90.0); -- Alice's submission for Assignment 2

-- Progress
INSERT INTO Progress (user_id, module_id, videos_watched, assignments_completed) VALUES
(1, 1, 2, 1), -- Alice watched 2 videos and completed 1 assignment in Module 1
(2, 1, 1, 1), -- Bob watched 1 video and completed 1 assignment in Module 1
(1, 2, 1, 1); -- Alice watched 1 video and completed 1 assignment in Module 2

-- Reviews
INSERT INTO Reviews (user_id, course_id, rating, comment) VALUES
(1, 1, 5, 'Great course for beginners!'),
(2, 1, 4, 'Very informative, but could use more examples.'),
(1, 2, 5, 'Loved the advanced topics!');

-- Payments
INSERT INTO Payments (user_id, course_id, amount, payment_date) VALUES
(1, 1, 99.99, '2023-11-01'),
(2, 1, 99.99, '2023-11-02'),
(1, 2, 149.99, '2023-11-03');
