# Specification: Scene Transition Signals

## 1. Overview
This track eliminates non-deterministic `create_timer` waits in the scene transition logic. By forcing the `SceneTransition` singleton to emit a signal when the screen is fully covered, we ensure the scene swap happens invisibly to the user regardless of framerate or loading hitches.

## 2. Functional Requirements
- **Signal Emission:** `SceneTransition` must emit `transition_halfway` ideally via an AnimationPlayer call method track or `animation_finished` signal check.
- **GameManager Waiting:** `GameManager` MUST await this signal before calling `change_scene_to_file` or `reload_current_scene`.

## 3. Acceptance Criteria
- [ ] No `create_timer` calls exist in `GameManager` for scene changing.
- [ ] Scene transitions are visually smooth (no "pop" of the new scene before the fade-in).
- [ ] GUT tests can `await` the signal to reliably test scene changes.
