// Function: Get Subject by ID
// Purpose: Retrieve a single subject by id with access control
// Returns: Subject record if user owns it, otherwise access denied
// Parameters:
//   - subject_id: ID of the subject to retrieve (required)
//   - user_id: ID of the requesting user (required for access control)

// Validation: Required parameters
if (!subject_id) {
  return {
    success: false,
    error: 'subject_id is required'
  };
}

if (!user_id) {
  return {
    success: false,
    error: 'user_id is required'
  };
}

// Query: Get subject by id
// SELECT * FROM subject WHERE id = subject_id

// Mock subject fetch (adaptar para Xano)
const subject = {
  id: subject_id,
  user_id: 123,
  name: 'Mathematics',
  description: 'Advanced calculus course',
  subject_category: 'Mathematics',
  academic_level: 'university',
  is_active: true,
  created_at: '2026-03-29T10:00:00Z',
  updated_at: '2026-03-29T10:00:00Z'
};

// Access control: Check if subject belongs to requesting user
if (!subject || subject.user_id !== user_id) {
  return {
    success: false,
    error: 'Access denied. Subject not found or does not belong to user.',
    status_code: 403
  };
}

return {
  success: true,
  data: subject
};
