// Function: Validate Subject Access
// Purpose: Helper function to check if user owns a subject
// Returns: Boolean - true if user has access, false otherwise
// Parameters:
//   - subject_id: ID of the subject (required)
//   - user_id: ID of the requesting user (required)

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

// Check if subject exists and belongs to user
if (!subject) {
  return {
    success: false,
    has_access: false,
    error: 'Subject not found'
  };
}

if (subject.user_id !== user_id) {
  return {
    success: false,
    has_access: false,
    error: 'Access denied. Subject does not belong to user.'
  };
}

return {
  success: true,
  has_access: true,
  subject: subject
};
