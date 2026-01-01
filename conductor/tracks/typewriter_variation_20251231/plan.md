# Implementation Plan: Quiz Audio Typewriter Variation

This plan covers the refactoring of typewriter sound logic to include randomization and a "no-repeat" constraint.

## Phase 1: Setup & Refactoring
- [x] Task: Create `tests/unit/test_QuizAudioManager.gd` with initial failing tests for `play_typewriter`.
- [x] Task: Rename `play_typeon()` to `play_typewriter()` in `src/components/QuizAudio.gd`.
- [x] Task: Update the caller in `src/scripts/GameSession.gd` (Line 152) to use `play_typewriter()`.
- [ ] Task: Conductor - User Manual Verification 'Setup & Refactoring' (Protocol in workflow.md)

## Phase 2: Implementation of Variation Logic (TDD)
- [ ] Task: Update `src/components/QuizAudio.gd` to export/reference the three typewriter SFX nodes.
- [ ] Task: Implement "no-repeat" randomization logic in `play_typewriter()`.
- [ ] Task: Verify that `test_QuizAudioManager.gd` passes, ensuring the no-repeat rule is respected.
- [ ] Task: Conductor - User Manual Verification 'Variation Logic' (Protocol in workflow.md)

## Phase 3: Final Integration & Cleanup
- [ ] Task: Verify the audio nodes in `src/scenes/quiz_scene.tscn` are correctly assigned in the editor (or through fallback logic).
- [ ] Task: Run full test suite to ensure no regressions in other audio functions.
- [ ] Task: Conductor - User Manual Verification 'Final Integration' (Protocol in workflow.md)
