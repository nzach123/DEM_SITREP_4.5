# Implementation Plan: Pause Menu UI Refactor

Unify the Pause Menu's visual identity with the `SettingsOverlay` to ensure a consistent, polished arcade aesthetic.

## Phase 1: Preparation & Testing
- [x] Task: Analysis - Document exact margins, separation constants, and component paths in `SettingsOverlay.tscn`.
- [x] Task: Write Failing Test - Verify `PauseMenu` button presence and signal wiring (Continue, Restart, Settings, Main Menu, Quit).
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Preparation' (Protocol in workflow.md)

## Phase 2: Visual & Structural Refactor
- [x] Task: Implementation - Replace `PauseMenu` center layout with a `Panel` matching `SettingsOverlay`'s style and dimensions.
- [x] Task: Implementation - Apply `Bebas_button_theme` to the Title and `Montserrat_button_theme` to all buttons.
- [x] Task: Implementation - Add `AnimationComponent` to all Pause Menu buttons for consistent micro-feedback.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Visual Refactor' (Protocol in workflow.md)

## Phase 3: Logic & Integration
- [x] Task: Implementation - Update `PauseMenu.gd` to handle new button signals and the application quit logic.
- [x] Task: Implementation - Update `GameManager.gd` to connect to `PauseMenu` signals and execute scene transitions (Reload, Main Menu).
- [x] Task: Verification - Ensure focus navigation works correctly with keyboard/gamepad across all menu buttons.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Logic & Integration' (Protocol in workflow.md)
