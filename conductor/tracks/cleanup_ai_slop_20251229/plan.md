# Implementation Plan - Refactor: Codebase Cleanup

## Phase 1: Preparation & Analysis
- [x] Task: Baseline Verification
    - **Goal:** Ensure the current state is stable before making changes.
    - **Action:** Run the full test suite.
    - **Command:** `C:\00_Godot\z_installer\Godot_v4.5.1-stable_win64_console.exe --headless -s addons/gut/gut_cmdln.gd -gdir=tests/unit -gexit`
- [x] Task: Identify Target Files
    - **Goal:** List all GDScript files in `src/` and `tests/` to systematically process.
    - **Action:** Run a glob search to create a working list of files.

## Phase 2: Cleanup Execution
- [x] Task: Refactor `src/autoload/`
    - **Goal:** Remove redundant comments and dead code from Autoload scripts (e.g., `GameManager.gd`, `SettingsManager.gd`).
    - **Verification:** Run tests.
- [x] Task: Refactor `src/scripts/` (UI & Overlay)
    - **Goal:** Clean up UI logic scripts (e.g., `SettingsOverlay.gd`, `CreditsOverlay.gd`).
    - **Verification:** Run tests.
- [x] Task: Refactor `src/components/` and `src/systems/`
    - **Goal:** Clean up component and system scripts.
    - **Verification:** Run tests.
- [x] Task: Refactor `tests/unit/`
    - **Goal:** Clean up test files themselves (removing commented out old tests).
    - **Verification:** Run tests.
- [x] Task: Conductor - User Manual Verification 'Cleanup Execution' (Protocol in workflow.md)

## Phase 3: Final Verification
- [x] Task: Final Regression Test
    - **Goal:** One final pass of the entire suite to guarantee no breakage.
    - **Command:** `C:\00_Godot\z_installer\Godot_v4.5.1-stable_win64_console.exe --headless -s addons/gut/gut_cmdln.gd -gdir=tests/unit -gexit`
