# Specification: MatchingEventPopup CRT Layering Fix

## Context
The user requires that the `MatchingEventPopup`, which appears during the `quiz_scene`, sits *behind* the CRT screen effect in the visual hierarchy. This ensures the retro CRT shader/overlay applies to the popup as well.

## Requirement
- Identify where `MatchingEventPopup` is instantiated during the `quiz_scene` lifecycle.
- Ensure the instance is added to the scene tree at an index *lower* than the `CRTScreen` node (or whatever node handles the CRT effect).
- This results in the `MatchingEventPopup` being rendered *before* the CRT overlay, so the CRT overlay is drawn on top.

## Acceptance Criteria
- `MatchingEventPopup` is instantiated as a child of the `QuizScene`.
- In the Scene Tree, `MatchingEventPopup` appears *above* the `CRTScreen` node (meaning it has a lower sibling index).
- Visually, the CRT effect applies to the popup.
