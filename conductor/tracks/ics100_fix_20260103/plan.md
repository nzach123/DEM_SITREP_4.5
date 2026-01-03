# Plan: Fix ICS100 Course Loading and Improve Menu Robustness

## Phase 1: Data Sanitation and Verification [checkpoint: 88ea559]
- [x] Task: Sanitize `ICS100.json` bcfef03
    - Remove all invalid `` markers from `assets/questions/ICS100.json`.
    - Verify JSON validity using a linter or online tool.
- [x] Task: Conductor - User Manual Verification 'Data Sanitation and Verification' (Protocol in workflow.md)

## Phase 2: Logic Hardening (Test Driven) [checkpoint: ea4a301]
- [x] Task: Create Test for Menu Filtering 4e5ea6e
    - Create `tests/unit/test_main_menu_filtering.gd`.
    - Test Case 1: `test_scan_valid_course` - Mock a valid "quiz" JSON and ensure it is added.
    - Test Case 2: `test_scan_invalid_course` - Mock a corrupt/invalid JSON and ensure it is NOT added.
- [x] Task: Implement Strict Filtering in `MainMenu.gd` 4e5ea6e
    - Modify `scan_courses()` to use `GameManager.get_course_type()`.
    - Implement the `if type == "quiz"` check.
    - Add the console warning for "unknown" types.
- [x] Task: Conductor - User Manual Verification 'Logic Hardening (Test Driven)' (Protocol in workflow.md)

## Phase 3: Final Integration Check
- [x] Task: Manual End-to-End Test a28a431
    - Run the game.
    - Select "ICS100" -> Difficulty -> Start.
    - Confirm first question loads.
    - (Optional) Create a dummy corrupt file in `assets/questions/` and verify it's excluded from the menu.
- [ ] Task: Conductor - User Manual Verification 'Final Integration Check' (Protocol in workflow.md)
