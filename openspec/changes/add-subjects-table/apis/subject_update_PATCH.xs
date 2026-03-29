// PATCH /api/subject/:id
// Update subject fields with access control
// URL params: id
// Request body: { name?, description?, subject_category?, academic_level? }
// Response: { id, name, updated_at, ... } or 403 Forbidden

// Authentication: Check if user is authenticated
if (!user || !user.id) {
  return {
    success: false,
    error: 'Unauthorized',
    status_code: 401
  };
}

// Validation: subject_id required
const subject_id = request_params.id;
if (!subject_id) {
  return {
    success: false,
    error: 'Subject ID is required',
    status_code: 400
  };
}

// Validation: request_body required
if (!request_body) {
  return {
    success: false,
    error: 'Request body is required',
    status_code: 400
  };
}

// Query: SELECT * FROM subject WHERE id = subject_id
// const subject = [result from query]
const subject = null; // Mock

if (!subject) {
  return {
    success: false,
    error: 'Subject not found',
    status_code: 404
  };
}

// Access control: Check ownership
if (subject.user_id !== user.id) {
  return {
    success: false,
    error: 'Access denied. Cannot modify subject that does not belong to you.',
    status_code: 403
  };
}

// Extract parameters from request
const { name, description, subject_category, academic_level } = request_body;

// Validation: name if provided
if (name !== undefined) {
  if (!name || name.length === 0 || name.length > 255) {
    return {
      success: false,
      error: 'Subject name must be 1-255 characters',
      status_code: 400
    };
  }
  subject.name = name;
}

// Validation: description if provided
if (description !== undefined) {
  if (description && description.length > 2000) {
    return {
      success: false,
      error: 'Description must be 2000 characters or less',
      status_code: 400
    };
  }
  subject.description = description;
}

// Validation: category if provided
if (subject_category !== undefined) {
  if (subject_category && subject_category.length > 100) {
    return {
      success: false,
      error: 'Category must be 100 characters or less',
      status_code: 400
    };
  }
  subject.subject_category = subject_category;
}

// Validation: academic_level if provided
if (academic_level !== undefined) {
  const validLevels = ['elementary', 'middle_school', 'high_school', 'university', null];
  if (academic_level && !validLevels.includes(academic_level)) {
    return {
      success: false,
      error: 'Invalid academic level',
      status_code: 400
    };
  }
  subject.academic_level = academic_level;
}

// Update timestamp
subject.updated_at = new Date().toISOString();

// Query: UPDATE subject SET ... WHERE id = subject_id

return {
  success: true,
  data: subject,
  status_code: 200
};
