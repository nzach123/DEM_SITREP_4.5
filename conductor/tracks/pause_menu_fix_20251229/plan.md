# Implementation Plan: Pause Menu & Quiz Crash Fix

This plan follows the Test-Driven Development (TDD) methodology and the project's established workflow.

## Phase 1: Bug Investigation and Fix (Quiz Crash)
- [x] Task: Investigation - Identify root cause of answer selection crash
- [x] Task: Write Failing Test - Reproduce crash scenario in a unit test [9a4ccdb]
- [x] Task: Implementation - Fix the crash bug in the Quiz scene logic [9a4ccdb]
- [x] Task: Verification - Ensure all tests pass and crash is resolved
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Bug Fix' (Protocol in workflow.md)

## Phase 2: Pause Menu UI Foundation
- [ ] Task: Write Failing Test - PauseMenu component initial state and visibility
- [ ] Task: Implementation - Create `PauseMenu.tscn` and `PauseMenu.gd` with basic layout (Resume, Settings, Quit)
- [ ] Task: Write Failing Test - Button signal emission
- [ ] Task: Implementation - Hook up signals for PauseMenu buttons
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Pause Menu Foundation' (Protocol in workflow.md)

## Phase 3: Pause Logic & Integration
- [ ] Task: Write Failing Test - Pause/Resume state management in Quiz scene
- [ ] Task: Implementation - Integrate PauseMenu into `Quiz.tscn` and implement toggle logic (Escape key)
- [ ] Task: Write Failing Test - Auto-pause on window focus loss
- [ ] Task: Implementation - Connect `MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT` to trigger pause
- [ ] Task: Write Failing Test - Timer control during pause
- [ ] Task: Implementation - Ensure quiz timer stops and starts correctly with pause state
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Logic & Integration' (Protocol in workflow.md)

## Phase 4: Styling & Final Polish
- [ ] Task: Implementation - Apply project Theme and "Intentional Arcade Minimalism" styling to PauseMenu
- [ ] Task: Implementation - Add background dimming/blur effect when paused
- [ ] Task: Implementation - Implement "Quit to Menu" navigation logic
- [ ] Task: Implementation - Connect "Settings" button to the existing Settings system
- [ ] Task: Conductor - User Manual Verification 'Phase 4: Styling & Final Polish' (Protocol in workflow.md)
