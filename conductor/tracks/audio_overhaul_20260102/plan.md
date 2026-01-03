# Implementation Plan: Audio System Overhaul & Adaptive Music

## Phase 1: Infrastructure & Testing Setup [checkpoint: 924396c]
- [x] Task: Create `tests/unit/test_audio_logic.gd` to verify adaptive threshold logic (State-based assertions).
- [x] Task: Configure `.import` settings for all background music files to `Loop: On`.
- [x] Task: Conductor - User Manual Verification 'Infrastructure & Testing Setup' (Protocol in workflow.md)

## Phase 2: Static Loops (Generic System)
- [x] Task: Implement `SceneAudioManager.gd` as a reusable component (exports `music_stream`).
- [x] Task: Integrate `SceneAudioManager` into `MainMenu.tscn` (Assign Menu Loop).
- [x] Task: Integrate `SceneAudioManager` into `AARScreen.tscn` (Assign AAR Loop).
- [x] Task: Conductor - User Manual Verification 'Static Loops' (Protocol in workflow.md)

## Phase 3: Adaptive Quiz Audio
- [x] Task: Write failing unit tests for `QuizAudioController` state transitions (High/Med/Low) based on Trust signal.
- [x] Task: Implement `QuizAudioController.gd` with signal-driven horizontal resequencing.
- [x] Task: Integrate `Quiz_Audio_Controller` node into `quiz_scene.tscn`.
- [x] Task: Conductor - User Manual Verification 'Adaptive Quiz Audio' (Protocol in workflow.md)

## Phase 4: Legacy Cleanup & Final Audit
- [x] Task: Audit `MainMenu.gd`, `quiz_scene.gd`, and `AARScreen.gd` to remove legacy audio timers/loops.
- [x] Task: Verify all new players are correctly routed to "Music" or "SFX" buses.
- [x] Task: Conductor - User Manual Verification 'Cleanup & Final Audit' (Protocol in workflow.md)
