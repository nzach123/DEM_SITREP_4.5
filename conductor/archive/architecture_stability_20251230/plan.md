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
- [x] Task: Conductor - User Manual Verification 'Phase 1: Type Safety & Component Definitions' (Protocol in workflow.md) [checkpoint: cc4076e]

## Phase 2: Core System Refactor (GameManager) [checkpoint: b78adcb]
- [x] Task: Decouple PauseMenu Lifecycle 3643eb9
...
- [x] Task: Secure Input Handling 3643eb9
- [x] Task: Conductor - User Manual Verification 'Phase 2: Core System Refactor (GameManager)' (Protocol in workflow.md)

## Phase 3: Component Logic Updates [checkpoint: b78adcb]
- [x] Task: Refactor MainMenu Implementation 17f7d93
...
- [x] Task: Implement Self-Cleanup in PauseMenu 079c785
- [x] Task: Conductor - User Manual Verification 'Phase 3: Component Logic Updates' (Protocol in workflow.md)

## Phase 4: Verification
- [x] Task: Regression Test Suite 2.506s
    - **Command:** `godot --headless -s addons/gut/gut_cmdln.gd -gdir=tests/unit -gexit`
    - **Checks:**
        1. Launch game -> Open/Close Pause Menu -> Change Scene -> Open Pause Menu (Verify no crash).
        2. Verify Course Cards populate correctly in Main Menu.
- [x] Task: Conductor - User Manual Verification 'Phase 4: Verification' (Protocol in workflow.md) [checkpoint: b78adcb]
