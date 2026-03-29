## 1. Database Table Creation

- [x] 1.1 Create `subject` table in Xano with fields: id (pk), user_id (fk), name, description, subject_category, academic_level, created_at, updated_at, is_active
- [x] 1.2 Set user_id as required foreign key reference to `user` table
- [x] 1.3 Set created_at and updated_at to auto-timestamp on insert/update
- [x] 1.4 Set is_active default to true
- [x] 1.5 Verify table structure in Xano UI

## 2. Indexing and Performance

- [x] 2.1 Create index on user_id for efficient "get subjects by user" queries
- [x] 2.2 Create index on created_at for sorting/pagination
- [x] 2.3 Create composite index on (user_id, is_active) for filtered queries
- [x] 2.4 Test query performance with sample data sets

## 3. Core Functions

- [x] 3.1 Create function to create a new subject with validation (name required, field length checks)
- [x] 3.2 Create function to retrieve all subjects for a user (with pagination support)
- [x] 3.3 Create function to retrieve a single subject by id with access control check
- [x] 3.4 Create function to update subject fields with validation
- [x] 3.5 Create function to soft-delete subject (set is_active = false)
- [x] 3.6 Add access control checks to all functions (user_id match required for update/delete)

## 4. API Endpoints

- [x] 4.1 Create POST /api/subject endpoint to create new subject
- [x] 4.2 Create GET /api/subject endpoint to list user's subjects with filters and pagination
- [x] 4.3 Create GET /api/subject/:id endpoint to retrieve single subject
- [x] 4.4 Create PATCH /api/subject/:id endpoint to update subject
- [x] 4.5 Create DELETE /api/subject/:id endpoint to soft-delete subject
- [x] 4.6 Add authentication middleware to all endpoints
- [x] 4.7 Add request/response validation to all endpoints

## 5. Testing and Validation

- [x] 5.1 Test subject creation with valid and invalid inputs
- [x] 5.2 Test subject retrieval and list filtering by category, academic_level, and is_active
- [x] 5.3 Test pagination returns correct page size and tokens
- [x] 5.4 Test access control - verify users can't access/modify other users' subjects
- [x] 5.5 Test soft delete - verify is_active is set to false and record preserved
- [x] 5.6 Test timestamp auto-population on create and update
- [x] 5.7 Verify foreign key constraint (user_id must reference valid user)

## 6. Documentation

- [x] 6.1 Document subject table schema in project documentation
- [x] 6.2 Document API endpoints and request/response formats
- [x] 6.3 Document access control rules for subjects
- [x] 6.4 Add code comments for validation and business logic
