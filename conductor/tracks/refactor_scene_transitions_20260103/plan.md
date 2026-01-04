# Implementation Plan: Scene Transition Signals

## Phase 1: Implementation
- [ ] Task: Refactor `SceneTransition.gd` to emit `transition_halfway` signal when screen is fully obscured.
- [ ] Task: Update `GameManager.change_scene` and `restart_level` to await `SceneTransition.transition_halfway`.
- [ ] Task: Remove `await get_tree().create_timer(...)` calls related to scene swapping.
- [ ] Task: Conductor - User Manual Verification 'Scene Transition Refactor' (Protocol in workflow.md)
