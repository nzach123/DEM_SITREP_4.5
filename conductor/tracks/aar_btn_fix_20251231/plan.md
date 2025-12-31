# Implementation Plan: AAR Screen Button Fix

This plan details the steps to correct the AAR screen button sizing issues and implement standard arcade micro-feedback.

## Phase 1: Analysis & Regression Setup [checkpoint: 7027f96]
- [x] Task: Analyze `src/scenes/AARScreen.tscn` and `src/scenes/MainMenu.tscn` to identify wrapper structure and existing feedback logic.
- [x] Task: Execute current GUT test suite to establish a passing baseline.
- [x] Task: Conductor - User Manual Verification 'Phase 1: Analysis' (Protocol in workflow.md)

## Phase 2: Structural Refactoring (The "Fix")
- [ ] Task: Create or update unit tests to verify AAR button presence and layout flags (Red Phase).
- [ ] Task: Remove animation wrappers and `AnimationPlayer` dependencies from Restart/HQ buttons in `AARScreen.tscn`.
- [ ] Task: Configure Restart and HQ buttons with `SIZE_EXPAND_FILL` in their parent container.
- [ ] Task: Verify implementation against layout tests (Green Phase).
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Structural Refactoring' (Protocol in workflow.md)

## Phase 3: Micro-Feedback Implementation
- [ ] Task: Implement hover/focus scale tween logic in `AARScreen.gd` (or relevant component) matching `MainMenu.tscn`.
- [ ] Task: Connect audio signals (hover/click) to buttons using the project's standard UI sound resources.
- [ ] Task: Add/Update tests to verify signals are connected and feedback logic is triggered.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Micro-Feedback' (Protocol in workflow.md)

## Phase 4: Final Validation
- [ ] Task: Run full GUT suite to ensure zero regressions across the project.
- [ ] Task: Perform manual visual check of AAR screen layout and button responsiveness.
- [ ] Task: Conductor - User Manual Verification 'Phase 4: Final Validation' (Protocol in workflow.md)
