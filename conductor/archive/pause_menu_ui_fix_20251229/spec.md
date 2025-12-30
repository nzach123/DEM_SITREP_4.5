# Track Specification: Bug Fix - Pause Menu Visibility & UI Enhancement

## Overview
Address the issue where the Pause Menu does not appear in the Quiz scene despite the game pausing. Additionally, modernize the Pause Menu UI to match the Settings Overlay and implement a navigation flow between them.

## Problem Diagnosis (Likely Causes)
1.  **Process Mode:** The Pause Menu or its parent (`crt_screen`) may have `process_mode` set to `Inherit` or `Pausable`, causing it to freeze when the tree is paused.
2.  **Z-Index/Layering:** The Quiz scene might have a `CanvasLayer` or UI elements with a higher `layer` or `z_index` than the Pause Menu's parent.
3.  **Parenting:** The Pause Menu might not be correctly instantiated or added as a child of the `crt_screen` in the Quiz scene context.

## Functional Requirements
1.  **Visibility Fix:**
    - Ensure the Pause Menu is instantiated and added under the `crt_screen` node when `Esc` is pressed.
    - Set the Pause Menu's `process_mode` to `ALWAYS` to ensure it remains active while the game is paused.
2.  **UI Alignment:**
    - Update the Pause Menu's visual style (fonts, colors, button styles) to mirror the existing `settings_overlay` scene.
3.  **Settings Integration:**
    - Replace the existing "Option" button with a "Settings" button.
    - **Navigation Logic:** Clicking "Settings" hides the Pause Menu and instantiates/shows the `settings_overlay`.
    - **Return Logic:** Closing the `settings_overlay` (via its "Back" or "Close" button) restores the Pause Menu's visibility.
4.  **Consistency:** Verify this behavior works correctly in both the Quiz scene and standard gameplay scenes.

## Non-Functional Requirements
- **Consistency:** Use the project's existing Theme resources for all UI elements.
- **Minimalism:** Maintain the "Intentional Arcade Minimalism" aesthetic.

## Acceptance Criteria
- [ ] Pressing `Esc` in the Quiz scene pauses the game AND displays the Pause Menu.
- [ ] The Pause Menu appears "behind" the CRT shader effect (placed under `crt_screen`).
- [ ] Clicking "Settings" in the Pause Menu opens the full Settings Overlay.
- [ ] Closing the Settings Overlay returns the user to the Pause Menu.
- [ ] The Pause Menu style matches the established project UI theme.
