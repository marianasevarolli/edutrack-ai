// Function: Soft Delete Subject
// Purpose: Mark subject as inactive (soft delete) with access control
// Returns: Confirmation or error
// Parameters:
//   - subject_id: ID of the subject to delete (required)
//   - user_id: ID of the requesting user (required for access control)

// Validation: Required parameters
if (!subject_id || !user_id) {
  return {
    success: false,
    error: 'subject_id and user_id are required'
  };
}

// Query: Get subject by id
// SELECT * FROM subject WHERE id = subject_id
const subject = {}; // Mock, adaptar para Xano

// Access control: Check ownership
if (!subject || subject.user_id !== user_id) {
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
    error: 'Subject is already deleted'
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
  }
};
