# Implementation Plan - Restore Dynamic Casualty Logic

## Phase 1: Data Structure Update
- [ ] Task: Update `DIFFICULTY_CONFIG` in `GameManager.gd`
    - **Goal:** Replace the static `casualty_penalty` with `casualty_min` and `casualty_max` ranges for all difficulty tiers.
    - **Action:** Modify `src/autoload/GameManager.gd`.
- [ ] Task: Baseline Test Creation
    - **Goal:** Create unit tests to verify the dynamic range logic.
    - **File:** `tests/unit/test_dynamic_casualties.gd`

## Phase 2: Logic Implementation
- [ ] Task: Implement Dynamic Calculation in `GameSession.gd`
    - **Goal:** Update `_handle_wrong` to use `randi_range` with the new config values.
    - **Action:** Modify `src/scripts/GameSession.gd`.
    - **Verification:** Run `test_dynamic_casualties.gd`.
- [ ] Task: Conductor - User Manual Verification 'Logic Implementation' (Protocol in workflow.md)

## Phase 3: Final Verification
- [ ] Task: Full Regression Test
    - **Goal:** Ensure the changes integrate correctly with the AAR screen and strike system.
    - **Command:** `C:\00_Godot\z_installer\Godot_v4.5.1-stable_win64_console.exe --headless -s addons/gut/gut_cmdln.gd -gdir=tests/unit -gexit`
