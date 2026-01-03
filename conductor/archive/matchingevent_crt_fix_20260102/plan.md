# Plan: MatchingEventPopup CRT Layering Fix

## Status
- [x] Task: Investigate `src/scenes/quiz_scene.tscn` and `src/scripts/GameSession.gd` (or relevant controller) to find where `MatchingEventPopup` is instantiated.
- [x] Task: Locate the `CRTScreen` node within the `quiz_scene` hierarchy.
- [x] Task: Modify the instantiation code to explicitly place `MatchingEventPopup` before `CRTScreen` using `move_child` or `add_child` with specific index logic.
- [x] Task: Verify the hierarchy order using a unit test or scene tree inspection.