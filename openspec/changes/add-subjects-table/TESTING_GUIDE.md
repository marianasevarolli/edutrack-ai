# Testing Subject Management Functionality

## 📋 Resumo
Plano de testes para validar toda a funcionalidade de gerenciamento de disciplinas (subjects).

## Test Setup

### Dados de Teste
- **User 1 ID:** 1
- **User 2 ID:** 2
- **Test User Email:** test@edutrack.com

### Ferramentas Recomendadas
- Postman ou Insomnia (para testes de API)
- Xano Test Runner (para testes de função)
- Manual testing via UI

---

## 5.1 Test Subject Creation (Valid & Invalid Inputs)

### Test Case 5.1.1: Create Subject - Valid Input
```
POST /api/subject
Authentication: User 1
Body: {
  "name": "Advanced Mathematics",
  "description": "Calculus and linear algebra",
  "subject_category": "Mathematics",
  "academic_level": "university"
}
Expected: 201 Created
Response includes: id, name, created_at, updated_at
✓ Subject created successfully
```

### Test Case 5.1.2: Create Subject - Minimal Valid Input
```
POST /api/subject
Authentication: User 1
Body: {
  "name": "Physics"
}
Expected: 201 Created
Response includes: id, name (only required field)
✓ Subject created with only name
```

### Test Case 5.1.3: Create Subject - Missing Name
```
POST /api/subject
Authentication: User 1
Body: {
  "description": "No name provided"
}
Expected: 400 Bad Request
Error: "Subject name is required and must be 1-255 characters"
✓ Validation error for missing name
```

### Test Case 5.1.4: Create Subject - Name Too Long
```
POST /api/subject
Authentication: User 1
Body: {
  "name": "[256+ character string]"
}
Expected: 400 Bad Request
Error: "Subject name is required and must be 1-255 characters"
✓ Validation error for name length
```

### Test Case 5.1.5: Create Subject - Description Too Long
```
POST /api/subject
Authentication: User 1
Body: {
  "name": "Valid Name",
  "description": "[2001+ character string]"
}
Expected: 400 Bad Request
Error: "Description must be 2000 characters or less"
✓ Validation error for description length
```

### Test Case 5.1.6: Create Subject - Invalid Academic Level
```
POST /api/subject
Authentication: User 1
Body: {
  "name": "Subject",
  "academic_level": "invalid_level"
}
Expected: 400 Bad Request
Error: "Academic level must be one of: elementary, middle_school, high_school, university"
✓ Validation error for invalid enum
```

### Test Case 5.1.7: Create Subject - Unauthenticated
```
POST /api/subject
Authentication: None
Body: { "name": "Subject" }
Expected: 401 Unauthorized
Error: "Unauthorized"
✓ Authentication required
```

---

## 5.2 Test Subject Retrieval & Filtering

### Test Case 5.2.1: List All User's Subjects
```
GET /api/subject
Authentication: User 1
Expected: 200 OK
Response: {
  subjects: [array of subjects owned by User 1],
  pagination: { page: 1, page_size: 20, total_count: N, ... }
}
✓ Returns only subjects of authenticated user
```

### Test Case 5.2.2: Filter by Category
```
GET /api/subject?category=Mathematics
Authentication: User 1
Expected: 200 OK
Response: subjects array with only subject_category = "Mathematics"
✓ Filter by category works
```

### Test Case 5.2.3: Filter by Academic Level
```
GET /api/subject?level=university
Authentication: User 1
Expected: 200 OK
Response: subjects array with only academic_level = "university"
✓ Filter by level works
```

### Test Case 5.2.4: Filter by Both Category and Level
```
GET /api/subject?category=Mathematics&level=university
Authentication: User 1
Expected: 200 OK
Response: subjects matching BOTH filters
✓ Multiple filters work together
```

### Test Case 5.2.5: Get Subject by ID - Own Subject
```
GET /api/subject/[subject_id_owned_by_user1]
Authentication: User 1
Expected: 200 OK
Response: Full subject details
✓ Can retrieve own subject
```

### Test Case 5.2.6: Get Subject by ID - Access Denied
```
GET /api/subject/[subject_id_owned_by_user2]
Authentication: User 1
Expected: 403 Forbidden
Error: "Access denied. Subject does not belong to you."
✓ Cannot access other user's subject
```

### Test Case 5.2.7: Get Subject by ID - Not Found
```
GET /api/subject/99999
Authentication: User 1
Expected: 404 Not Found
Error: "Subject not found"
✓ Non-existent subject returns 404
```

---

## 5.3 Test Pagination

### Test Case 5.3.1: Pagination - Default Page Size
```
GET /api/subject
Authentication: User 1
Expected: Returns up to 20 results (default page_size)
pagination.page_size: 20
✓ Default page size is 20
```

### Test Case 5.3.2: Pagination - Custom Page Size
```
GET /api/subject?page_size=10
Authentication: User 1
Expected: Returns up to 10 results
pagination.page_size: 10
✓ Custom page size works
```

### Test Case 5.3.3: Pagination - Page Size Cap
```
GET /api/subject?page_size=200
Authentication: User 1
Expected: Returns max 100 results (capped)
pagination.page_size: 100
✓ Page size capped at 100
```

### Test Case 5.3.4: Pagination - Invalid Page
```
GET /api/subject?page=0
Authentication: User 1
Expected: 400 Bad Request
Error: "Page must be >= 1"
✓ Invalid page returns 400
```

### Test Case 5.3.5: Pagination - Second Page
```
GET /api/subject?page=2&page_size=10
Expected: pagination indicates page 2 of X
pagination.page: 2
pagination.has_previous: true
✓ Second page works correctly
```

### Test Case 5.3.6: Pagination - Last Page
```
GET /api/subject?page=[last_page]
Expected: pagination.has_next: false
✓ Last page correctly identified
```

### Test Case 5.3.7: Pagination - Sorting by Date
```
GET /api/subject?page=1
Expected: Results sorted by created_at DESC (newest first)
Verify: First subject.created_at >= Last subject.created_at
✓ Results sorted descending by date
```

---

## 5.4 Test Access Control

### Test Case 5.4.1: Update Own Subject
```
PATCH /api/subject/[subject_id_owned_by_user1]
Authentication: User 1
Body: { "name": "New Name" }
Expected: 200 OK
✓ User can update own subject
```

### Test Case 5.4.2: Update Other User's Subject - Denied
```
PATCH /api/subject/[subject_id_owned_by_user2]
Authentication: User 1
Body: { "name": "Hacked Name" }
Expected: 403 Forbidden
Error: "Access denied. Cannot modify subject that does not belong to you."
✓ User cannot update other's subject
```

### Test Case 5.4.3: Delete Own Subject
```
DELETE /api/subject/[subject_id_owned_by_user1]
Authentication: User 1
Expected: 200 OK
✓ User can delete own subject
```

### Test Case 5.4.4: Delete Other User's Subject - Denied
```
DELETE /api/subject/[subject_id_owned_by_user2]
Authentication: User 1
Expected: 403 Forbidden
Error: "Access denied. Cannot delete subject that does not belong to you."
✓ User cannot delete other's subject
```

---

## 5.5 Test Soft Delete

### Test Case 5.5.1: Soft Delete - Sets is_active to false
```
DELETE /api/subject/[subject_id]
Authentication: User 1
Expected: 200 OK
Verify in Database: subject.is_active = false
✓ Soft delete sets is_active to false
```

### Test Case 5.5.2: Soft Deleted Subject Not in List
```
GET /api/subject
Authentication: User 1
Expected: Deleted subject NOT in results
Verify: subject.is_active = true for all returned subjects
✓ Soft deleted subjects excluded from list
```

### Test Case 5.5.3: Get Soft Deleted Subject - Access Denied
```
GET /api/subject/[soft_deleted_subject_id]
Authentication: User 1 (owner)
Expected: 404 Not Found OR filtered by is_active
✓ Cannot retrieve soft-deleted subject
```

### Test Case 5.5.4: Delete Already Deleted Subject
```
DELETE /api/subject/[already_deleted_subject_id]
Authentication: User 1
Expected: 410 Gone
Error: "Subject is already deleted"
✓ Double delete returns 410 Gone
```

### Test Case 5.5.5: Audit Trail Preserved
```
Database Query: SELECT * FROM subject WHERE id = [deleted_id]
Expected: Record still exists with is_active = false
✓ Soft delete preserves data for audit trail
```

---

## 5.6 Test Timestamps

### Test Case 5.6.1: Created_at Auto-Set
```
POST /api/subject
Body: { "name": "Test Subject" }
Expected Response includes:
  created_at: [current timestamp ISO 8601]
✓ created_at auto-populated on create
```

### Test Case 5.6.2: Updated_at Auto-Set
```
POST /api/subject
Body: { "name": "Test Subject" }
Expected Response includes:
  updated_at: [same as created_at initially]
✓ updated_at auto-populated on create
```

### Test Case 5.6.3: Updated_at Changes on Update
```
1. Create subject (created_at = T1, updated_at = T1)
2. Wait 1 second
3. PATCH /api/subject/[id] with new name
Expected:
  created_at: T1 (unchanged)
  updated_at: T2 (where T2 > T1)
✓ updated_at updated on patch
```

### Test Case 5.6.4: Timestamps Format
```
Response timestamps in ISO 8601 format: "2026-03-29T10:00:00Z"
✓ Timestamps in correct format
```

---

## 5.7 Test Foreign Key Constraint

### Test Case 5.7.1: Create Subject - Valid User Reference
```
POST /api/subject (with valid user_id in database)
Expected: 201 Created
Subject.user_id references valid user
✓ Valid user reference accepted
```

### Test Case 5.7.2: User Owns Subjects
```
Query: SELECT * FROM subject WHERE user_id = [valid_user_id]
Expected: Results returned (no constraint violation)
✓ Foreign key constraint working
```

### Test Case 5.7.3: Cascade/Reference on User Delete
(This test depends on database cascade settings)
```
If user deleted, what happens to their subjects?
Expected: Either cascade delete or prevent delete
Verify: Database behavior is as designed
✓ Foreign key cascade behavior documented
```

---

## Summary Checklist

- [ ] 5.1 - Create with valid/invalid inputs working
- [ ] 5.2 - Retrieval and filtering working  
- [ ] 5.3 - Pagination working with all parameters
- [ ] 5.4 - Access control enforced correctly
- [ ] 5.5 - Soft delete working and preserved
- [ ] 5.6 - Timestamps auto-populated correctly
- [ ] 5.7 - Foreign key relationships validated
