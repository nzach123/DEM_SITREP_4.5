# Specification - Architecture & Stability Refactor (Dec 2025)

## Overview
This track aims to eliminate "Zombie Menu" crashes (where the `GameManager` retains references to freed UI objects) and improve codebase maintainability by enforcing strict typing across the UI layer and standardizing input context handling.

## Functional Requirements
- **Strict Typing (UI Stack):** All scripts in `src/ui/` and key components (e.g., `CourseCard`) must define a `class_name`. Direct method calls (`object.method()`) must replace fragile `call("method")` patterns.
- **On-Demand Pause Menu:** `GameManager` will no longer hold a persistent reference to a `PauseMenu` instance. It will instantiate the menu only when requested and ensure it is properly cleaned up (`queue_free`) when dismissed.
- **Pause Menu Reset:** Every time the Pause Menu is summoned, it must initialize in its default/root state.
- **Input Context Awareness:**
    - `MainMenu` and other major UI screens must be added to the `"menu"` group.
    - `GameManager` must verify the current scene is NOT in the `"menu"` group before processing "Pause" input toggles to prevent menu-on-menu overlaps.

## Non-Functional Requirements
- **Stability:** Eliminate "Accessed freed instance" errors in the debugger.
- **Type Safety:** Maximize Godot's static typing benefits for IDE completion and compile-time error catching.

## Acceptance Criteria
1. The game can be paused and unpaused in a gameplay scene without crashes.
2. Scene transitions (e.g., Gameplay -> Main Menu) do not leave "zombie" references in `GameManager`.
3. Pressing the "Pause" key (ESC) while in the Main Menu does not trigger the Pause Menu.
4. All UI scripts in `src/ui/` have a `class_name` and use typed references.

## Out of Scope
- Implementing a persistent state for Pause Menu sub-pages.
- Refactoring gameplay-specific systems (Physics, Combat, etc.) unless required for stability.
