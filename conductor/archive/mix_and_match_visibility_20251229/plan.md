# Plan: Fix MixAndMatch (MatchingEventPopup) Visibility and CRT Redundancy

This plan addresses the invisibility of the `MatchingEventPopup` by removing redundant CRT layers and ensuring correct scene tree placement within `GameSession`.

## Phase 1: Infrastructure & Initial Testing
- [x] Task: Create unit test to verify `MatchingEventPopup` initialization and presence of `CRTScreen`.
- [x] Task: Create unit test for `GameSession` to verify popup instantiation logic.
- [x] Task: Conductor - User Manual Verification 'Phase 1: Infrastructure' (Protocol in workflow.md)

## Phase 2: Cleanup MatchingEventPopup
- [x] Task: Remove `CRTScreen` node from `MatchingEventPopup.tscn`.
- [x] Task: Update `MatchingEventPopup.gd` to remove references to the deleted `crt_screen` node.
- [x] Task: Update unit tests to reflect the removal of the local CRT screen.
- [x] Task: Conductor - User Manual Verification 'Phase 2: Cleanup' (Protocol in workflow.md)

## Phase 3: Integration & Placement
- [x] Task: Modify `GameSession.gd` to instantiate `MatchingEventPopup` as a child of the main `CRTScreen` (or a node drawn before it).
- [x] Task: Verify that `MatchingEventPopup` is visible and interactive when triggered.
- [x] Task: Ensure the popup's "completed" signal correctly resumes the game state.
- [x] Task: Conductor - User Manual Verification 'Phase 3: Integration' (Protocol in workflow.md)

## Phase 4: Final Verification
- [~] Task: Run all unit tests to ensure no regressions in `GameSession` or `MatchingEventPopup`.
- [ ] Task: Perform manual playtest to trigger the Field Exercise and verify visual/input flow.
- [ ] Task: Conductor - User Manual Verification 'Phase 4: Final Verification' (Protocol in workflow.md)
