/*
 * Online Learning Platform - Database Schema
 * ===========================================
 * 
 * This script creates all tables required for the Online Learning Platform
 * and ensures compatibility with all functions, triggers, and sample data.
 * 
 * CRITICAL REQUIREMENTS FOR TRIGGERS & SAMPLE DATA:
 * 1. Progress table MUST have UNIQUE(user_id, module_id) constraint
 *    - Required for ON CONFLICT logic in fn_update_progress and fn_update_assignment_progress
 * 2. VideoWatch table MUST exist with proper foreign keys
 *    - Required by trg_video_watched trigger
 *    - Sample data includes video watch history for all students
 * 3. All tables with child records use ON DELETE CASCADE
 *    - Ensures data consistency when parent records are deleted
 * 4. Payment partitions cover all years in sample data
 *    - Partitions: 2023, 2024, 2026 (year of sample data)
 * 
 * Sample Data Compatibility:
 * - 5 users: 3 students (Alice, Bob, Diana), 1 instructor (Charlie), 1 admin
 * - 4 courses: SQL Intro, Advanced PostgreSQL, Database Design, Data Science
 * - 13 modules total: 4 in Intro, 3 in Advanced, 3 in Design, 3 in Data Science
 * - 13 videos: distributed across modules with realistic duration
 * - VideoWatch records: 16 video watches tracked for trigger demonstration
 * - 7 assignments: one per module with JSON details
 * - 9 submissions: varying grades from 82-98 demonstrating student performance
 * - Progress initialized: shows different completion levels (0%-80%+)
 * - 4 reviews: diverse feedback on courses
 * - 6 payments: 2 from 2024, 4 from 2026 (partition testing)
 * 
 * Table Dependencies:
 *   Users (base)
 *   ├── Courses
 *   │   ├── Modules
 *   │   │   ├── Videos
 *   │   │   │   └── VideoWatch (tracks watches for trg_video_watched)
 *   │   │   ├── Assignments
 *   │   │   │   └── Submissions (triggers fn_update_assignment_progress)
 *   │   │   └── Progress (updated by both triggers)
 *   │   ├── Enrollments (protected by fn_check_enrollment trigger)
 *   │   └── Reviews
 *   └── Payments (partitioned by date)
 * 
 * Functions Using These Tables:
 *   - fn_check_enrollment(): Enrollments (read) - validates enrollment uniqueness
 *   - fn_calculate_completion(): Progress, Enrollments, Modules (read) - calculates %
 *   - fn_get_student_progress(): Progress, Modules (read) - aggregates metrics
 *   - fn_update_progress(): Progress (write via INSERT...ON CONFLICT) - auto-tracks videos
 *   - fn_update_assignment_progress(): Progress, Assignments (write) - auto-tracks assignments
 * 
 * Usage:
 * 1. CREATE all tables using this script
 * 2. CREATE indexes using idx_performance.sql
 * 3. CREATE functions using fn_*.sql files
 * 4. CREATE triggers using trg_*.sql files
 * 5. LOAD sample data using Sample Data.sql
 */

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
    instructor_id INT REFERENCES Users(user_id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Enrollments Table
-- IMPORTANT: Protected by trg_prevent_duplicate_enrollment trigger (calls fn_check_enrollment)
-- The UNIQUE constraint AND trigger together provide robust duplicate prevention
CREATE TABLE Enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    course_id INT REFERENCES Courses(course_id) ON DELETE CASCADE,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, course_id) -- Prevent duplicate enrollments
);

-- Modules Table
CREATE TABLE Modules (
    module_id SERIAL PRIMARY KEY,
    course_id INT REFERENCES Courses(course_id) ON DELETE CASCADE,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    order_number INT NOT NULL
);

-- Videos Table
CREATE TABLE Videos (
    video_id SERIAL PRIMARY KEY,
    module_id INT REFERENCES Modules(module_id) ON DELETE CASCADE,
    title VARCHAR(100) NOT NULL,
    url VARCHAR(255) NOT NULL,
    duration INT NOT NULL -- Duration in seconds
);

-- VideoWatch Table
-- IMPORTANT: Required by trg_video_watched trigger to track when users watch videos
-- Triggers: trg_video_watched (calls fn_update_progress when a video is watched)
CREATE TABLE VideoWatch (
    watch_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    video_id INT REFERENCES Videos(video_id) ON DELETE CASCADE,
    module_id INT REFERENCES Modules(module_id) ON DELETE CASCADE,
    watched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, video_id) -- Prevent recording duplicate watches by same user
);

-- Assignments Table
CREATE TABLE Assignments (
    assignment_id SERIAL PRIMARY KEY,
    module_id INT REFERENCES Modules(module_id) ON DELETE CASCADE,
    title VARCHAR(100) NOT NULL,
    details JSONB, -- Flexible structure for assignment details
    due_date TIMESTAMP
);

-- Submissions Table
-- IMPORTANT: Triggers trg_update_assignment_progress (calls fn_update_assignment_progress)
-- This table is the source of assignment tracking; every INSERT updates Progress.assignments_completed
CREATE TABLE Submissions (
    submission_id SERIAL PRIMARY KEY,
    assignment_id INT REFERENCES Assignments(assignment_id) ON DELETE CASCADE,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    grade DECIMAL(5, 2) CHECK (grade >= 0 AND grade <= 100),
    UNIQUE (assignment_id, user_id) -- Prevent duplicate submissions
);

-- Progress Table
-- IMPORTANT: The UNIQUE constraint on (user_id, module_id) is REQUIRED
-- for the ON CONFLICT logic used in fn_update_progress and fn_update_assignment_progress triggers
CREATE TABLE Progress (
    progress_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    module_id INT REFERENCES Modules(module_id) ON DELETE CASCADE,
    videos_watched INT DEFAULT 0,
    assignments_completed INT DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, module_id), -- Required for trigger ON CONFLICT logic
    CHECK (videos_watched >= 0 AND assignments_completed >= 0) -- Prevent negative values
);

-- Reviews Table
CREATE TABLE Reviews (
    review_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    course_id INT REFERENCES Courses(course_id) ON DELETE CASCADE,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Payments Table
CREATE TABLE Payments (
    payment_id SERIAL,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    course_id INT REFERENCES Courses(course_id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (payment_id, payment_date)
) PARTITION BY RANGE (payment_date); -- Partitioning by date

CREATE TABLE Payments_2023 PARTITION OF Payments
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE Payments_2024 PARTITION OF Payments
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE Payments_2026 PARTITION OF Payments
    FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');

