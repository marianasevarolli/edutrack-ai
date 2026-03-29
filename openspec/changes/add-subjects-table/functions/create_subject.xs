// Function: Create Subject
// Purpose: Create a new subject with validation
// Returns: Created subject record with id and timestamps
// Parameters:
//   - user_id: ID of the user creating the subject
//   - name: Subject name (required, max 255 chars)
//   - description: Optional description (max 2000 chars)
//   - subject_category: Optional category (max 100 chars)
//   - academic_level: Optional level (elementary, middle_school, high_school, university)

// Validation: Name is required and not empty
if (!name || name.length === 0 || name.length > 255) {
  return {
    success: false,
    error: 'Subject name is required and must be 1-255 characters'
  };
}

// Validation: Description max length
if (description && description.length > 2000) {
  return {
    success: false,
    error: 'Description must be 2000 characters or less'
  };
}

// Validation: Category max length
if (subject_category && subject_category.length > 100) {
  return {
    success: false,
    error: 'Category must be 100 characters or less'
  };
}

// Validation: Academic level enumeration
const validLevels = ['elementary', 'middle_school', 'high_school', 'university'];
if (academic_level && !validLevels.includes(academic_level)) {
  return {
    success: false,
    error: `Academic level must be one of: ${validLevels.join(', ')}`
  };
}

// Create the subject record
const newSubject = {
  user_id: user_id,
  name: name,
  description: description || null,
  subject_category: subject_category || null,
  academic_level: academic_level || null,
  is_active: true,
  created_at: new Date().toISOString(),
  updated_at: new Date().toISOString()
};

return {
  success: true,
  data: newSubject
};
