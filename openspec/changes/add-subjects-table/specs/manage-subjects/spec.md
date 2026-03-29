## ADDED Requirements

### Requirement: User can create a new subject
The system SHALL allow authenticated users to create a new subject and automatically assign ownership to the current user.

#### Scenario: Create subject successfully
- **WHEN** user provides subject name and optional description within valid constraints
- **THEN** system creates the subject, assigns it to the user, and returns the created subject with id and timestamps

#### Scenario: Create subject with missing required fields
- **WHEN** user attempts to create a subject without a name
- **THEN** system rejects the request and returns a validation error

### Requirement: User can view their own subjects
The system SHALL allow authenticated users to retrieve all subjects belonging to them, with filtering and sorting options.

#### Scenario: Retrieve all subjects for authenticated user
- **WHEN** user requests their subjects without filters
- **THEN** system returns a paginated list of all subjects owned by the user, sorted by creation date descending

#### Scenario: Retrieve subject by id
- **WHEN** user requests a specific subject by id
- **THEN** if the subject belongs to the user, system returns the full subject details; otherwise returns 403 Forbidden

### Requirement: User can update their own subjects
The system SHALL allow authenticated users to modify fields of subjects they own.

#### Scenario: Update subject details
- **WHEN** user provides new values for name, description, category, or academic level
- **THEN** system updates the subject fields and refreshes the updated_at timestamp

#### Scenario: Attempt to update another user's subject
- **WHEN** user attempts to update a subject owned by a different user
- **THEN** system returns 403 Forbidden

### Requirement: User can delete their own subjects
The system SHALL allow authenticated users to delete subjects they own.

#### Scenario: Delete subject successfully
- **WHEN** user requests deletion of their own subject
- **THEN** system deletes or marks as inactive the subject (based on soft delete policy)

#### Scenario: Attempt to delete another user's subject
- **WHEN** user attempts to delete a subject owned by a different user
- **THEN** system returns 403 Forbidden

### Requirement: List subjects with filters and pagination
The system SHALL support filtering subjects by category, academic level, and active status, with cursor or offset-based pagination.

#### Scenario: Filter subjects by academic level
- **WHEN** user requests their subjects filtered by "university" level
- **THEN** system returns only subjects with academic_level = "university"

#### Scenario: Paginate through large subject list
- **WHEN** user requests subjects with page size limit (e.g., 20 results)
- **THEN** system returns paginated results with pagination tokens/offsets for next/previous pages
