// Function: Get User Subjects
// Purpose: Retrieve all subjects for a user with filtering and pagination
// Returns: Array of subject records with pagination info
// Parameters:
//   - user_id: ID of the user (required)
//   - filter_category: Optional filter by subject_category
//   - filter_level: Optional filter by academic_level
//   - filter_active: Boolean to filter by is_active status (default: true)
//   - page: Page number (default: 1)
//   - page_size: Records per page (default: 20, max: 100)

// Validation: user_id required
if (!user_id) {
  return {
    success: false,
    error: 'user_id is required'
  };
}

// Pagination defaults
const pageNum = page || 1;
const pageSize = Math.min(page_size || 20, 100); // Cap at 100
const offset = (pageNum - 1) * pageSize;

// Build query filters
let filters = {
  user_id: user_id,
  is_active: filter_active !== false ? true : filter_active
};

if (filter_category) {
  filters.subject_category = filter_category;
}

if (filter_level) {
  filters.academic_level = filter_level;
}

// Build query (pseudo-code, adaptar para Xano query syntax)
// SELECT * FROM subject 
// WHERE user_id = user_id AND is_active = true [AND filters]
// ORDER BY created_at DESC
// LIMIT page_size OFFSET offset

return {
  success: true,
  data: {
    subjects: [], // Array of subject records
    pagination: {
      page: pageNum,
      page_size: pageSize,
      total_count: 0, // Total matching subjects
      total_pages: 0,
      has_previous: pageNum > 1,
      has_next: false // Calculated based on total_count
    }
  }
};
