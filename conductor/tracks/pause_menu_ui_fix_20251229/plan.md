# Implementation Plan: Pause Menu Visibility & UI Enhancement

## Overview
This plan addresses the pause menu visibility issue in the Quiz scene and modernizes the UI to align with the Settings Overlay. It follows a TDD approach and ensures the menu is correctly layered under the CRT screen node.

## Phase 1: Diagnosis & Visibility Fix
Goal: Ensure the Pause Menu is visible in all gameplay scenes, specifically under the `crt_screen` node in the Quiz scene.

- [x] Task: Create unit tests in `tests/unit/test_pause_menu_visibility.gd` to verify Pause Menu instantiation and parenting. 3b539d9
- [x] Task: Modify `src/autoload/GameManager.gd` to improve Pause Menu lifecycle management. 3b539d9
- [x] Task: Verify the fix in the Quiz scene. 3b539d9
- [x] Task: Conductor - User Manual Verification 'Phase 1: Visibility Fix' (Protocol in workflow.md) 3b539d9

## Phase 2: UI Modernization & Settings Alignment
Goal: Update the Pause Menu look and feel to match `SettingsOverlay.tscn` and implement the "Settings" button swap logic.

- [x] Task: Create unit tests in `tests/unit/test_pause_menu_ui.gd` to verify Settings navigation logic. 3b539d9
- [x] Task: Update `src/scenes/PauseMenu.tscn` layout and styling. 3b539d9
- [x] Task: Update `src/scripts/PauseMenu.gd` to handle the Settings swap. 3b539d9
- [x] Task: Verify UI consistency and navigation flow. 3b539d9
- [x] Task: Conductor - User Manual Verification 'Phase 2: UI Modernization' (Protocol in workflow.md) 3b539d9

## Phase 3: Final Verification & Polish
Goal: Ensure stability across all scenes and clean up any legacy code.

- [x] Task: Run all UI-related tests to ensure no regressions. 3b539d9
- [x] Task: Perform a final manual pass in the Main Menu, Quiz Scene, and AAR Screen. 3b539d9
- [x] Task: Conductor - User Manual Verification 'Phase 3: Final Polish' (Protocol in workflow.md) 3b539d9