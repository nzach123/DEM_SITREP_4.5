# Plan: Fix AAR Screen Music Playback

## Phase 1: Diagnosis & Preparation
- [ ] Task: Inspect `AARScreen.tscn` to verify `AARAudioManager` node existence and the `audio_manager` export assignment in the root `AARScreen` node.
- [ ] Task: Verify `AARAudioManager` child nodes (`SFX_Success`, `SFX_Fail`) have valid `AudioStream` resources (Ogg/Wav) assigned.
- [ ] Task: Check `default_bus_layout.tres` to ensure "Master" or any custom audio buses are not muted or set to -80dB.
- [ ] Task: Conductor - User Manual Verification 'Diagnosis & Preparation' (Protocol in workflow.md)

## Phase 2: Implementation (TDD)
- [ ] Task: Write failing test in `tests/unit/test_aar_audio_fix.gd` that attempts to trigger `play_victory_music` and checks if the player starts.
- [ ] Task: Update `AARAudioManager.gd` with improved error handling and explicit `play()` calls to pass the tests.
- [ ] Task: Update `AARScreen.gd` to ensure the `audio_manager` is ready before calling playback methods.
- [ ] Task: Conductor - User Manual Verification 'Implementation (TDD)' (Protocol in workflow.md)

## Phase 3: Final Verification
- [ ] Task: Execute a manual playtest by triggering the AAR screen with a high score (Victory) and a low score (Fail).
- [ ] Task: Verify the Godot console/debugger is free of audio-related errors.
- [ ] Task: Conductor - User Manual Verification 'Final Verification' (Protocol in workflow.md)
