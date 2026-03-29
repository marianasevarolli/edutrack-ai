// Function: Update Subject
// Purpose: Update subject fields with validation and access control
// Returns: Updated subject record or error
// Parameters:
//   - subject_id: ID of the subject to update (required)
//   - user_id: ID of the requesting user (required for access control)
//   - name: New name (optional, max 255)
//   - description: New description (optional, max 2000)
//   - subject_category: New category (optional, max 100)
//   - academic_level: New level (optional)

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
    error: 'Access denied. Cannot modify subject that does not belong to you.',
    status_code: 403
  };
}

// Validation: Name if provided
if (name !== undefined) {
  if (!name || name.length === 0 || name.length > 255) {
    return {
      success: false,
      error: 'Subject name must be 1-255 characters'
    };
  }
  subject.name = name;
}

// Validation: Description if provided
if (description !== undefined) {
  if (description && description.length > 2000) {
    return {
      success: false,
      error: 'Description must be 2000 characters or less'
    };
  }
  subject.description = description;
}

// Validation: Category if provided
if (subject_category !== undefined) {
  if (subject_category && subject_category.length > 100) {
    return {
      success: false,
      error: 'Category must be 100 characters or less'
    };
  }
  subject.subject_category = subject_category;
}

// Validation: Academic level if provided
if (academic_level !== undefined) {
  const validLevels = ['elementary', 'middle_school', 'high_school', 'university', null];
  if (!validLevels.includes(academic_level)) {
    return {
      success: false,
      error: 'Invalid academic level'
    };
  }
  subject.academic_level = academic_level;
}

// Update timestamp
subject.updated_at = new Date().toISOString();

// Query: UPDATE subject SET ... WHERE id = subject_id

return {
  success: true,
  data: subject
};
