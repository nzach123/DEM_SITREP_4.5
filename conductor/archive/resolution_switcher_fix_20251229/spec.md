# Specification: Resolution Switcher Fix

## Overview
Fixes an error ("Embedded window only supports Windowed mode") that occurs when attempting to change resolutions while running the game from the Godot Editor. The fix involves detecting the environment and disabling the resolution selection when it's not supported, providing clear feedback to the user.

## Functional Requirements
- **Environment Detection:** The `SettingsOverlay` must detect if it is running in a context that does not support window resizing (e.g., Godot Editor's embedded window, potentially certain Web environments).
- **UI Locking:** If resizing is unsupported:
    - The Resolution `OptionButton` must be disabled (`disabled = true`).
    - A tooltip must be added to the `OptionButton` explaining: "Resolution locked in this mode/environment."
- **Safe Application:** Ensure `SettingsManager` does not attempt to call `DisplayServer.window_set_size()` if the environment is unsupported, even if the UI somehow triggers an apply.

## Non-Functional Requirements
- **UX Clarity:** The user should immediately understand why they cannot change the resolution.

## Acceptance Criteria
- [ ] Running the game in the Godot Editor disables the Resolution dropdown.
- [ ] Hovering over the disabled Resolution dropdown shows the explanatory tooltip.
- [ ] No "Embedded window" errors are logged to the console when interacting with the Settings menu in the Editor.
- [ ] Resolution switching remains functional in standalone Desktop exports.

## Out of Scope
- Implementing custom viewport scaling for the Editor.
- Fixing other window mode issues (e.g., Fullscreen in Web).
