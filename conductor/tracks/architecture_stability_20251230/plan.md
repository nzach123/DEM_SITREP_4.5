# Implementation Plan - Refactor: Architecture & Stability

## Phase 1: Type Safety & Component Definitions
- [x] Task: Enforce Strict Typing on UI Components 3099435
    - **Target:** `src/scenes/CourseCard.gd`, `src/scripts/SettingsOverlay.gd`, `src/scripts/CreditsOverlay.gd`.
    - **Action:** Add `class_name` to these scripts (`CourseCard`, `SettingsOverlay`, `CreditsOverlay`).
    - **Reasoning:** Enables static typing and eliminates fragile `call("method_name")` usage.
- [x] Task: Standardize Main Menu Grouping 72ed94e
    - **Target:** `src/scripts/MainMenu.gd`.
    - **Action:** Add `add_to_group("main_menu")` in `_ready()`.
    - **Reasoning:** Replaces brittle string checks (`if name == "MainMenu"`) with robust group checks for input handling.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Type Safety & Component Definitions' (Protocol in workflow.md)

## Phase 2: Core System Refactor (GameManager)
- [ ] Task: Decouple PauseMenu Lifecycle
    - **Target:** `src/autoload/GameManager.gd`.
    - **Action:**
        1. Remove persistent `pause_menu_instance` variable.
        2. Implement `_summon_pause_menu()` to instantiate only on demand.
        3. Implement `_dismiss_pause_menu()` to close/cleanup.
    - **Reasoning:** Prevents "Freed Object" crashes when scene switching deletes the menu parent but `GameManager` retains the reference.
- [ ] Task: Secure Input Handling
    - **Target:** `src/autoload/GameManager.gd`.
    - **Action:** Modify `_unhandled_input` to check `current_scene.is_in_group("main_menu")` before processing pause toggle.
    - **Reasoning:** Prevents input bleed where ESC closes a popup in the menu but also triggers the pause logic.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Core System Refactor (GameManager)' (Protocol in workflow.md)

## Phase 3: Component Logic Updates
- [ ] Task: Refactor MainMenu Implementation
    - **Target:** `src/scripts/MainMenu.gd`.
    - **Action:**
        1. Cast instances to `CourseCard` type.
        2. Replace `card.call("setup", ...)` with direct `card.setup(...)`.
    - **Reasoning:** Leverages the new `class_name` definitions for compile-time safety.
- [ ] Task: Implement Self-Cleanup in PauseMenu
    - **Target:** `src/scripts/PauseMenu.gd`.
    - **Action:** Ensure `queue_free()` is called after the close animation completes.
    - **Reasoning:** Prevents memory leaks now that `GameManager` creates fresh instances.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Component Logic Updates' (Protocol in workflow.md)

## Phase 4: Verification
- [ ] Task: Regression Test Suite
    - **Command:** `godot --headless -s addons/gut/gut_cmdln.gd -gdir=tests/unit -gexit`
    - **Checks:**
        1. Launch game -> Open/Close Pause Menu -> Change Scene -> Open Pause Menu (Verify no crash).
        2. Verify Course Cards populate correctly in Main Menu.
- [ ] Task: Conductor - User Manual Verification 'Phase 4: Verification' (Protocol in workflow.md)
