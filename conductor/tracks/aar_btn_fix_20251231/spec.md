# Specification: AAR Screen Button Fix

## 1. Overview
The Restart and HQ buttons on the After Action Report (AAR) screen currently suffer from sizing issues caused by an animation wrapper, which forces them to shrink to their text width. This track aims to remove the problematic wrapper and animation, enforcing equal width for both buttons while re-introducing arcade-style micro-feedback (scale and sound) consistent with the Main Menu.

## 2. Functional Requirements
*   **Remove Wrappers:** Delete the animation wrapper nodes currently parenting the Restart and HQ buttons in `src/scenes/AARScreen.tscn`.
*   **Equal Layout:** Configure both buttons to use `SIZE_EXPAND_FILL` (or equivalent Container sizing flags) to ensure they share the available horizontal space equally.
*   **Micro-Feedback:**
    *   Implement **Hover/Focus Scale**: Buttons should subtly scale up when hovered or focused, matching the behavior found in `src/scenes/MainMenu.tscn`.
    *   Implement **Audio Feedback**: Buttons must play the standard UI hover and click sounds used in the Main Menu.

## 3. Non-Functional Requirements
*   **Arcade Minimalism:** Adhere to the project's design philosophy. Avoid decorative clutter.
*   **Godot Native:** Use native Control node sizing and Tween/Theme properties for feedback rather than complex `AnimationPlayer` setups if possible.

## 4. Acceptance Criteria
*   [ ] Restart and HQ buttons appear with equal width on the AAR screen.
*   [ ] Buttons do not shrink to fit their text content.
*   [ ] Hovering over a button triggers a subtle scale animation.
*   [ ] Hovering and clicking triggers the correct audio feedback.
*   [ ] "Restart" restarts the level; "HQ" returns to the Main Menu.
*   [ ] **Regression Check:** All GUT tests must pass after removing the wrappers. Any failures encountered must be resolved before marking the track complete.
