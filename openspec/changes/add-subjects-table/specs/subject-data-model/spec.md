## ADDED Requirements

### Requirement: Subject data structure and validation
The system SHALL enforce a standardized subject data model with required and optional fields, with proper validation rules.

#### Scenario: Valid subject data
- **WHEN** subject data includes id, user_id (foreign key), name, optional description, optional category, optional academic_level, created_at, updated_at, and is_active
- **THEN** system accepts and stores the subject following the defined schema

#### Scenario: Subject name validation
- **WHEN** creating or updating a subject with a name field
- **THEN** system validates that name is a non-empty string with max length 255 characters

#### Scenario: Academic level enumeration
- **WHEN** creating or updating a subject with academic_level
- **THEN** system validates that academic_level (if provided) is one of: "elementary", "middle_school", "high_school", "university", or null

### Requirement: User ownership relationship
The system SHALL maintain a foreign key relationship between subjects and users to enforce ownership.

#### Scenario: Subject assigned to user
- **WHEN** a subject is created
- **THEN** system stores the user_id of the authenticated user in the subject record

#### Scenario: Orphaned subjects prevented
- **WHEN** attempting to create a subject without a user_id
- **THEN** system rejects the request with a validation error

### Requirement: Timestamp tracking
The system SHALL automatically track subject creation and modification times.

#### Scenario: Timestamps on creation
- **WHEN** user creates a subject
- **THEN** system automatically sets created_at and updated_at to the current timestamp

#### Scenario: Timestamp on update
- **WHEN** user updates a subject field
- **THEN** system updates the updated_at timestamp; created_at remains unchanged

### Requirement: Active status flag
The system SHALL support tracking whether a subject is active or deleted (soft delete).

#### Scenario: Subject created as active
- **WHEN** creating a subject
- **THEN** system sets is_active to true by default

#### Scenario: Retrieving only active subjects
- **WHEN** user queries subjects without specifying deleted items
- **THEN** system returns only subjects where is_active = true

#### Scenario: Soft delete preserves history
- **WHEN** user deletes a subject
- **THEN** system sets is_active = false, preserving the record for audit trails and foreign key references from other tables
