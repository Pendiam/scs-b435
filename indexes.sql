
-- Progress Table Indexes
-- These are CRITICAL - triggers query/update Progress heavily
CREATE INDEX idx_progress_user_module ON Progress(user_id, module_id);
-- Alternative for checking existing progress (used in both triggers' ON CONFLICT)
CREATE INDEX idx_progress_user ON Progress(user_id);
-- Alternative for queries grouping by course
CREATE INDEX idx_progress_module ON Progress(module_id);

-- VideoWatch Table Indexes
-- The trg_video_watched trigger reads VideoWatch records very frequently
CREATE INDEX idx_videowatch_user ON VideoWatch(user_id);
CREATE INDEX idx_videowatch_module ON VideoWatch(module_id);
CREATE INDEX idx_videowatch_user_module ON VideoWatch(user_id, module_id);

-- Assignments Table Indexes
-- fn_update_assignment_progress looks up module_id by assignment_id
CREATE INDEX idx_assignments_module ON Assignments(module_id);
