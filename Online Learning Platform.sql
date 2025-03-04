-- Users Table
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('student', 'instructor', 'admin')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Courses Table
CREATE TABLE Courses (
    course_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    instructor_id INT REFERENCES Users(user_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Enrollments Table
CREATE TABLE Enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    course_id INT REFERENCES Courses(course_id),
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, course_id) -- Prevent duplicate enrollments
);

-- Modules Table
CREATE TABLE Modules (
    module_id SERIAL PRIMARY KEY,
    course_id INT REFERENCES Courses(course_id),
    title VARCHAR(100) NOT NULL,
    description TEXT,
    order_number INT NOT NULL
);

-- Videos Table
CREATE TABLE Videos (
    video_id SERIAL PRIMARY KEY,
    module_id INT REFERENCES Modules(module_id),
    title VARCHAR(100) NOT NULL,
    url VARCHAR(255) NOT NULL,
    duration INT NOT NULL -- Duration in seconds
);

-- Assignments Table
CREATE TABLE Assignments (
    assignment_id SERIAL PRIMARY KEY,
    module_id INT REFERENCES Modules(module_id),
    title VARCHAR(100) NOT NULL,
    details JSONB, -- Flexible structure for assignment details
    due_date TIMESTAMP
);

-- Submissions Table
CREATE TABLE Submissions (
    submission_id SERIAL PRIMARY KEY,
    assignment_id INT REFERENCES Assignments(assignment_id),
    user_id INT REFERENCES Users(user_id),
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    grade DECIMAL(5, 2) CHECK (grade >= 0 AND grade <= 100),
    UNIQUE (assignment_id, user_id) -- Prevent duplicate submissions
);

-- Progress Table
CREATE TABLE Progress (
    progress_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    module_id INT REFERENCES Modules(module_id),
    videos_watched INT DEFAULT 0,
    assignments_completed INT DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reviews Table
CREATE TABLE Reviews (
    review_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    course_id INT REFERENCES Courses(course_id),
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Payments Table
CREATE TABLE Payments (
    payment_id SERIAL,
    user_id INT REFERENCES Users(user_id),
    course_id INT REFERENCES Courses(course_id),
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    PRIMARY KEY (payment_id, payment_date)
) PARTITION BY RANGE (payment_date); -- Partitioning by date

CREATE TABLE Payments_2023 PARTITION OF Payments
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');
