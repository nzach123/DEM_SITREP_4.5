# Implementation Plan: Pause System Refactor

## Phase 1: GameOverlay Implementation
- [ ] Task: Create `src/scenes/GameOverlay.tscn` (CanvasLayer) and `src/autoload/GameOverlay.gd`.
- [ ] Task: Move `PauseMenu` instantiation logic into `GameOverlay`.
- [ ] Task: Add `GameOverlay` as an Autoload in `project.godot`.

## Phase 2: GameManager Decoupling
- [ ] Task: Refactor `GameManager` to remove direct reference to `PauseMenu` scene.
- [ ] Task: Update `GameManager.toggle_pause()` to call `GameOverlay.set_paused(bool)`.
- [ ] Task: Ensure `PauseMenu` signals (resume, quit) call back to `GameManager` methods correctly.
- [ ] Task: Conductor - User Manual Verification 'Pause System Refactor' (Protocol in workflow.md)
