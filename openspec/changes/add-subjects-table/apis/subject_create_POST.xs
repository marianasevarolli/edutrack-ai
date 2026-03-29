// POST /api/subject
// Create a new subject
// Request body: { name, description?, subject_category?, academic_level? }
// Response: { id, user_id, name, created_at, updated_at, ... }

// Authentication: Check if user is authenticated
if (!user || !user.id) {
  return {
    success: false,
    error: 'Unauthorized',
    status_code: 401
  };
}

// Request validation: Body must exist
if (!request_body) {
  return {
    success: false,
    error: 'Request body is required',
    status_code: 400
  };
}

// Extract parameters from request
const { name, description, subject_category, academic_level } = request_body;

// Call validation function (same as 3.1)
if (!name || name.length === 0 || name.length > 255) {
  return {
    success: false,
    error: 'Subject name is required and must be 1-255 characters',
    status_code: 400
  };
}

if (description && description.length > 2000) {
  return {
    success: false,
    error: 'Description must be 2000 characters or less',
    status_code: 400
  };
}

if (subject_category && subject_category.length > 100) {
  return {
    success: false,
    error: 'Category must be 100 characters or less',
    status_code: 400
  };
}

const validLevels = ['elementary', 'middle_school', 'high_school', 'university'];
if (academic_level && !validLevels.includes(academic_level)) {
  return {
    success: false,
    error: `Academic level must be one of: ${validLevels.join(', ')}`,
    status_code: 400
  };
}

// Create subject (call function or inline logic)
const now = new Date().toISOString();
const newSubject = {
  user_id: user.id,
  name: name,
  description: description || null,
  subject_category: subject_category || null,
  academic_level: academic_level || null,
  is_active: true,
  created_at: now,
  updated_at: now
};

// Query: INSERT INTO subject VALUES (...)
// subject.id = [generated id from database]

return {
  success: true,
  data: newSubject,
  status_code: 201
};
