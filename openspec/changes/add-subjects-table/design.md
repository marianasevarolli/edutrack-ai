## Context

The EduTrack AI platform is built on Xano as a backend-as-a-service solution. Users are already authenticated through native Xano authentication (`user` table exists). The platform will grow to include subject management, recommendations, automations, and event logging. 

The `subject` table will be the foundational data model for tracking academic disciplines owned by users. This table must support future features like role-based access control, subject-specific analytics, and automation rules.

## Goals / Non-Goals

**Goals:**
- Design a flexible, performant data model for subjects that supports ownership and future access controls
- Store essential academic discipline metadata (name, description, category, level)
- Implement proper indexing for fast lookups by user and timestamps
- Enable future APIs and automations to reference subjects reliably
- Support soft deletes for audit trails (if applicable to platform policy)

**Non-Goals:**
- Creating actual API endpoints (that's a separate change/feature)
- Implementing access control logic (that will be in middleware/functions)
- Building subject recommendation algorithms
- Creating subject templates or hierarchies (future enhancement)

## Decisions

### 1. Table Structure and Schema (User Ownership Model)
**Decision**: The `subject` table will include `user_id` as a foreign key reference to enforce ownership at the data layer.

**Rationale**: 
- Prevents users from accidentally accessing other users' subjects
- Simplifies access control logic in APIs and functions
- Standard pattern in multi-tenant applications

**Schema fields**:
- `id` (primary key)
- `user_id` (foreign key to `user` table) - required
- `name` (text, required) - subject name/title
- `description` (text, optional) - detailed description
- `subject_category` (text, optional) - academic category (e.g., "Mathematics", "Literature")
- `academic_level` (text, optional) - e.g., "elementary", "high_school", "university"
- `created_at` (timestamp) - audit trail
- `updated_at` (timestamp) - track modifications
- `is_active` (boolean, default true) - for soft deletes if needed

### 2. Indexing Strategy
**Decision**: Create indexes on `user_id`, `created_at`, and composite index on `(user_id, is_active)` for efficient filtering.

**Rationale**:
- `user_id` index enables fast lookups of "all subjects for this user"
- `created_at` supports sorting/pagination features
- Composite index optimizes the common filter pattern "get active subjects for user"

### 3. Naming Convention
**Decision**: Use snake_case for field names, align with Xano conventions.

**Rationale**: Consistency with existing table schemas in the system (user, account, etc.)

## Risks / Trade-offs

**[Scalability]** → As subject count grows per user, queries with `user_id` filter need proper pagination. Mitigation: Document pagination requirements in specs and implement cursor-based or offset-based pagination.

**[Future Relationships]** → Future features (automations, event logging) will add foreign keys to `subject`. Mitigation: Design for extensibility; use standard naming for related fields.

**[Data Integrity]** → Soft deletes via `is_active` flag may lead to logical complexity. Mitigation: Always include `is_active = true` in default queries; document this pattern.

## Migration Plan

1. Create `subject` table in Xano database
2. Add indexes on `user_id`, `created_at`, and composite index
3. Verify table creation via Xano UI and data integrity checks
4. Document table schema in project (schema.md in specs)
5. Once verified, specs and tasks for CRUD operations can proceed

## Open Questions

- Should we track additional metadata like color coding or tags for subjects? (Defer to future enhancement)
- Do we need soft deletes or hard deletes? (Recommend soft deletes for audit trail; clarify in product requirements)
- Should subject names be unique per user? (Recommend allowing duplicates for now, revisit if needed)
