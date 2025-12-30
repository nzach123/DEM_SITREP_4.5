# Specification: Pause Menu UI Refactor

## 1. Overview
Update the `PauseMenu` scene to visually and structurally mirror the `SettingsOverlay` scene. This ensures a consistent "Intentional Arcade Minimalism" aesthetic across the application, unifying fonts, spacing, and button styles.

## 2. Visual Requirements
- **Reference:** Use `src/scenes/SettingsOverlay.tscn` as the source of truth for layout and style.
- **Typography:**
  - **Headers:** Bebas Neue
  - **Body/UI:** Rajdhani and/or Mon (matching `SettingsOverlay` weights and usage).
- **Components:**
  - Match button dimensions, padding, and alignment.
  - Replicate hover and pressed states from the Settings menu.
  - Maintain the "Arcade" minimal layout hierarchy (no decorative clutter).

## 3. Functional Requirements
The Pause Menu must include and wire the following buttons:
1.  **Continue:** Unpauses the game and hides the menu.
2.  **Restart:** Reloads the current active scene/level.
3.  **Settings:** (Existing) Opens the `SettingsOverlay`.
4.  **Main Menu:** Returns the user to the Main Menu scene.
5.  **Quit:** Exits the application entirely.

## 4. Technical Requirements
- **Input Handling:** Buttons must focus correctly for keyboard/gamepad navigation.
- **State Management:** Ensure consistent behavior when switching between Pause and Settings overlays.
