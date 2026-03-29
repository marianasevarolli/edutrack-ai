// GET /api/subject/:id
// Retrieve a single subject by id with access control
// URL params: id
// Response: { id, user_id, name, ... } or 403 Forbidden

// Authentication: Check if user is authenticated
if (!user || !user.id) {
  return {
    success: false,
    error: 'Unauthorized',
    status_code: 401
  };
}

// Validation: subject_id parameter required
const subject_id = request_params.id;
if (!subject_id) {
  return {
    success: false,
    error: 'Subject ID is required',
    status_code: 400
  };
}

// Validation: subject_id must be numeric
const id_numeric = parseInt(subject_id);
if (isNaN(id_numeric)) {
  return {
    success: false,
    error: 'Subject ID must be numeric',
    status_code: 400
  };
}

// Query: SELECT * FROM subject WHERE id = subject_id
// const subject = [result from query]
const subject = null; // Mock

// Check if subject exists
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
    error: 'Access denied. Subject does not belong to you.',
    status_code: 403
  };
}

return {
  success: true,
  data: subject,
  status_code: 200
};
