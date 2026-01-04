# Specification: SessionContext Extraction

## 1. Overview
This track extracts all ephemeral session data (scores, logs, stats) from the persistent `GameManager` autoload into a dedicated `SessionContext` resource. This enables easier resetting of game state and improves serialization for save/load.

## 2. Functional Requirements
- **Resource-Based State:** `current_score`, `citizens_saved`, `session_log`, etc. must exist ONLY in `SessionContext`.
- **GameManager Role:** `GameManager` acts as the holder of the *current* `SessionContext` instance.
- **Reset:** Calling `GameManager.start_new_session()` should simply assign `current_session = SessionContext.new()`.
- **Typing:** `SessionContext` must use `class_name SessionContext`.

## 3. Acceptance Criteria
- [ ] `GameManager` no longer contains integer/array variables for score or logs.
- [ ] Starting a new game properly resets all stats (verified by checking `GameManager.session` values).
- [ ] Save/Load system serializes the `SessionContext` resource (or its dictionary representation).
- [ ] All existing game logic (scoring, logging) functions correctly with the new structure.
