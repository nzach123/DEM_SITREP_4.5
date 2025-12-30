# Specification: Fix MixAndMatch (MatchingEventPopup) Visibility and CRT Redundancy

## Overview
The `MixAndMatch` (MatchingEventPopup) scene is currently invisible and appears to freeze the game when triggered during a `GameSession`. This is due to incorrect scene-tree placement and redundant CRT screen effects.

## Problem Analysis
1.  **Invisibility:** The popup is instantiated as a child of the `QuizScene` root node. Since it is added dynamically, it is drawn after the main `CRTScreen` node. The combination of two CRT overlays and draw order issues is likely preventing it from rendering correctly.
2.  **Redundant CRT:** Both `quiz_scene.tscn` and `MatchingEventPopup.tscn` have a `CRTScreen` overlay. This results in two CRT effects at runtime, which is inefficient and causes visual issues.
3.  **Frozen State:** The "freeze" is an input block caused by `current_state = State.LOCKED` in `GameSession.gd`. Since the popup is invisible, the player cannot interact with it to progress, leaving the game in a locked state.

## Requirements
1.  **Remove Duplicate CRT:** Remove the `CRTScreen` node and its associated shader from `MatchingEventPopup.tscn`.
2.  **Correct Placement:** Modify `GameSession.gd` to instantiate the popup as a child of the existing `CRTScreen` node in `QuizScene` (as requested) or a dedicated container that ensures it is rendered *before* the CRT effect is applied.
3.  **Ensure Visibility:** Ensure `MatchingEventPopup` is properly shown and receives input.

## Functional Requirements
-   `MatchingEventPopup` must be visible when triggered.
-   `MatchingEventPopup` must be affected by the `QuizScene`'s CRT effect.
-   The game must resume correctly after the popup is completed.

## Acceptance Criteria
-   The `MatchingEventPopup` appears on screen when the Field Exercise triggers.
-   The popup has the same CRT scanline/distortion effect as the rest of the game.
-   The `MatchingEventPopup.tscn` file no longer contains a `CRTScreen` node.
-   The popup is spawned correctly in the hierarchy of `QuizScene`.
