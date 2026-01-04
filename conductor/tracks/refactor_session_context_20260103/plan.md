# Implementation Plan: SessionContext Extraction

## Phase 1: Implementation
- [x] Task: Create `src/resources/SessionContext.gd` with properties (`current_score`, etc.) and methods.
- [x] Task: Create `tests/unit/test_session_context.gd` to verify resource behavior.
- [x] Task: Refactor `GameManager` to use `SessionContext` resource.
- [x] Task: Update all call sites (search for `GameManager.current_score`, etc.) to use `GameManager.session`.
- [ ] Task: Conductor - User Manual Verification 'SessionContext Refactor' (Protocol in workflow.md)
