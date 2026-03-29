// DELETE /api/subject/:id
// Soft delete a subject with access control
// URL params: id
// Response: { success, message } or 403 Forbidden

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
    error: 'Access denied. Cannot delete subject that does not belong to you.',
    status_code: 403
  };
}

// Check if already deleted
if (!subject.is_active) {
  return {
    success: false,
    error: 'Subject is already deleted',
    status_code: 410 // Gone
  };
}

// Perform soft delete: set is_active = false
subject.is_active = false;
subject.updated_at = new Date().toISOString();

// Query: UPDATE subject SET is_active = false, updated_at = NOW() WHERE id = subject_id

return {
  success: true,
  message: 'Subject deleted successfully',
  data: {
    id: subject_id,
    is_active: false
  },
  status_code: 200
};
