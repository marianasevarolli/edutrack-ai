# Subject Management API - Complete Documentation

## 📚 Table of Contents
1. [Overview](#overview)
2. [Data Model](#data-model)
3. [API Endpoints](#api-endpoints)
4. [Access Control](#access-control)
5. [Code Examples](#code-examples)

---

## Overview

The Subject Management API allows authenticated users to create, read, update, and delete academic subjects (disciplines) they own. Each subject is owned by a single user and supports filtering by category and academic level.

**Base URL:** `/api/subject`

All endpoints require authentication and support JSON request/response format.

---

## Data Model

### Subject Table Schema

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `id` | Auto-Increment (PK) | Yes | - | Unique identifier |
| `user_id` | Foreign Key | Yes | - | Owner of the subject (references `user` table) |
| `name` | Text (255) | Yes | - | Subject name/title |
| `description` | Text (2000) | No | null | Detailed description |
| `subject_category` | Text (100) | No | null | Academic category (e.g., Mathematics) |
| `academic_level` | Enum | No | null | Grade level (elementary, middle_school, high_school, university) |
| `is_active` | Boolean | Yes | true | Soft delete flag |
| `created_at` | Timestamp | Yes | NOW() | Record creation time |
| `updated_at` | Timestamp | Yes | NOW() | Last modification time |

### Database Indexes

- **idx_user_id**: On `user_id` for fast owner lookups
- **idx_created_at**: On `created_at` for sorting and pagination
- **idx_user_active**: Composite on `(user_id, is_active)` for filtered queries

---

## API Endpoints

### 1. POST /api/subject — Create Subject

**Description:** Create a new subject for the authenticated user.

**Request:**
```
POST /api/subject
Content-Type: application/json
Authorization: [User Session]

{
  "name": "Advanced Mathematics",
  "description": "Calculus and linear algebra course",
  "subject_category": "Mathematics",
  "academic_level": "university"
}
```

**Parameters:**
| Name | Type | Required | Max Length | Notes |
|------|------|----------|-----------|-------|
| name | string | Yes | 255 | Subject name |
| description | string | No | 2000 | Optional description |
| subject_category | string | No | 100 | Optional category |
| academic_level | enum | No | - | Values: elementary, middle_school, high_school, university |

**Response (201 Created):**
```json
{
  "success": true,
  "data": {
    "id": 123,
    "user_id": 1,
    "name": "Advanced Mathematics",
    "description": "Calculus and linear algebra course",
    "subject_category": "Mathematics",
    "academic_level": "university",
    "is_active": true,
    "created_at": "2026-03-29T10:00:00Z",
    "updated_at": "2026-03-29T10:00:00Z"
  }
}
```

**Errors:**
| Status | Error | Cause |
|--------|-------|-------|
| 400 | Subject name is required and must be 1-255 characters | Invalid name |
| 400 | Description must be 2000 characters or less | Description too long |
| 400 | Category must be 100 characters or less | Category too long |
| 400 | Academic level must be one of: ... | Invalid level |
| 401 | Unauthorized | Not authenticated |

---

### 2. GET /api/subject — List Subjects

**Description:** Retrieve list of subjects owned by the authenticated user with optional filters and pagination.

**Request:**
```
GET /api/subject?page=1&page_size=20&category=Mathematics&level=university
Authorization: [User Session]
```

**Query Parameters:**
| Name | Type | Default | Max | Description |
|------|------|---------|-----|-------------|
| page | integer | 1 | - | Page number (>= 1) |
| page_size | integer | 20 | 100 | Records per page |
| category | string | - | 100 | Filter by subject_category |
| level | string | - | - | Filter by academic_level |

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "subjects": [
      {
        "id": 123,
        "user_id": 1,
        "name": "Advanced Mathematics",
        "subject_category": "Mathematics",
        "academic_level": "university",
        "created_at": "2026-03-29T10:00:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "page_size": 20,
      "total_count": 50,
      "total_pages": 3,
      "has_previous": false,
      "has_next": true
    }
  }
}
```

**Errors:**
| Status | Error | Cause |
|--------|-------|-------|
| 400 | Page must be >= 1 | Invalid page |
| 400 | page_size must be between 1 and 100 | Invalid page size |
| 401 | Unauthorized | Not authenticated |

---

### 3. GET /api/subject/:id — Get Subject

**Description:** Retrieve a single subject by ID. Only returns if subject belongs to authenticated user.

**Request:**
```
GET /api/subject/123
Authorization: [User Session]
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": 123,
    "user_id": 1,
    "name": "Advanced Mathematics",
    "description": "Calculus and linear algebra course",
    "subject_category": "Mathematics",
    "academic_level": "university",
    "is_active": true,
    "created_at": "2026-03-29T10:00:00Z",
    "updated_at": "2026-03-29T10:00:00Z"
  }
}
```

**Errors:**
| Status | Error | Cause |
|--------|-------|-------|
| 400 | Subject ID must be numeric | Non-numeric ID |
| 401 | Unauthorized | Not authenticated |
| 403 | Access denied. Subject does not belong to you. | Not the owner |
| 404 | Subject not found | ID doesn't exist |

---

### 4. PATCH /api/subject/:id — Update Subject

**Description:** Update one or more fields of a subject. Only subject owner can update.

**Request:**
```
PATCH /api/subject/123
Content-Type: application/json
Authorization: [User Session]

{
  "name": "Updated Subject Name",
  "description": "New description",
  "subject_category": "Science"
}
```

**Parameters:**
Same as POST /api/subject, but all fields are optional.

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": 123,
    "user_id": 1,
    "name": "Updated Subject Name",
    "description": "New description",
    "subject_category": "Science",
    "academic_level": "university",
    "is_active": true,
    "created_at": "2026-03-29T10:00:00Z",
    "updated_at": "2026-03-29T10:30:00Z"
  }
}
```

**Errors:**
| Status | Error | Cause |
|--------|-------|-------|
| 400 | Validation error messages | Invalid field values |
| 401 | Unauthorized | Not authenticated |
| 403 | Access denied. Cannot modify subject... | Not the owner |
| 404 | Subject not found | ID doesn't exist |

---

### 5. DELETE /api/subject/:id — Delete Subject

**Description:** Soft delete a subject (set is_active = false). Only subject owner can delete.

**Request:**
```
DELETE /api/subject/123
Authorization: [User Session]
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Subject deleted successfully",
  "data": {
    "id": 123,
    "is_active": false
  }
}
```

**Errors:**
| Status | Error | Cause |
|--------|-------|-------|
| 401 | Unauthorized | Not authenticated |
| 403 | Access denied. Cannot delete subject... | Not the owner |
| 404 | Subject not found | ID doesn't exist |
| 410 | Subject is already deleted | Already soft-deleted |

---

## Access Control

### Ownership Rules
- Each subject has a `user_id` field linking to its owner
- Users can only access/modify subjects they own
- Access violations return **403 Forbidden**

### Request-Level Checks
```
All endpoints check:
1. User is authenticated (401 Unauthorized if not)
2. User owns the resource (403 Forbidden if not owner)
3. Request data is valid (400 Bad Request if invalid)
```

### Special Cases
- **List endpoint (GET /api/subject)**: Automatically filters by authenticated user's ID
- **Get by ID (GET /api/subject/:id)**: Checks ownership, returns 403 if not owner
- **Update/Delete**: Checks ownership, returns 403 if not owner

---

## Code Examples

### Create Subject (cURL)
```bash
curl -X POST http://localhost/api/subject \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer [token]" \
  -d '{
    "name": "Physics",
    "subject_category": "Sciences",
    "academic_level": "high_school"
  }'
```

### List User's Subjects (JavaScript)
```javascript
async function getUserSubjects() {
  const response = await fetch('/api/subject?page=1&page_size=20', {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`
    }
  });
  
  const data = await response.json();
  if (data.success) {
    console.log('Subjects:', data.data.subjects);
    console.log('Pagination:', data.data.pagination);
  } else {
    console.error('Error:', data.error);
  }
}
```

### Update Subject (JavaScript)
```javascript
async function updateSubject(subjectId, updates) {
  const response = await fetch(`/api/subject/${subjectId}`, {
    method: 'PATCH',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`
    },
    body: JSON.stringify(updates)
  });
  
  const data = await response.json();
  if (response.status === 200) {
    console.log('Subject updated:', data.data);
  } else {
    console.error(`Error (${response.status}):`, data.error);
  }
}
```

### Delete Subject (Python)
```python
import requests

def delete_subject(subject_id, token):
    headers = {
        'Authorization': f'Bearer {token}'
    }
    
    response = requests.delete(
        f'http://localhost/api/subject/{subject_id}',
        headers=headers
    )
    
    data = response.json()
    if response.status_code == 200:
        print(f"Subject {subject_id} deleted")
    else:
        print(f"Error ({response.status_code}): {data['error']}")
```

---

## Validation Rules Reference

### Name Field
- **Required:** Yes
- **Type:** String
- **Length:** 1-255 characters
- **Pattern:** No special validation (any non-empty string allowed)

### Description Field
- **Required:** No
- **Type:** String (or null)
- **Max Length:** 2000 characters
- **Pattern:** No special validation

### Subject Category Field
- **Required:** No
- **Type:** String (or null)
- **Max Length:** 100 characters
- **Examples:** Mathematics, Literature, Sciences, History, Physical Education

### Academic Level Field
- **Required:** No
- **Type:** Enum (or null)
- **Valid Values:**
  - `elementary` - Elementary/Primary school
  - `middle_school` - Middle school
  - `high_school` - High school
  - `university` - University/College level

---

## Business Logic Notes

1. **Soft Deletes:** Deleted subjects (is_active = false) are preserved in the database for audit trails and foreign key references.

2. **Timestamps:** Both `created_at` and `updated_at` are auto-populated by the system and cannot be manually set.

3. **Pagination:** Results are sorted by `created_at DESC` (newest first). Sorting by other fields is not currently supported.

4. **Filtering:** Multiple filters use AND logic (e.g., `category=Mathematics AND level=university`).

5. **Foreign Key:** The `user_id` field is a required foreign key to the `user` table. Creating subjects for other users is not possible through the API.

---

## Future Enhancements

- Subject templates and hierarchies
- Subject-specific automations and recommendations
- Subject tagging and custom attributes
- Integration with course scheduling
- Analytics and usage tracking per subject
