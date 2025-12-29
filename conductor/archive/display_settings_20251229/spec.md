# Specification: Display Settings Enhancements

## Overview
This track implements a robust display settings system within the existing `SettingsManager`. It allows players to choose from standard 16:9 resolutions, toggle between various window modes, and manually apply these changes. It also ensures the game handles manual window resizing gracefully by maintaining the intended aspect ratio.

## Functional Requirements
- **Resolution Selection:** 
    - Provide a dropdown (OptionButton) with standard 16:9 resolutions:
        - 1280x720
        - 1366x768
        - 1600x900
        - 1920x1080
        - 2560x1440
        - 3840x2160
- **Window Mode Selection:**
    - Provide options for:
        - Windowed
        - Exclusive Fullscreen
        - Borderless Fullscreen
- **Apply Logic:**
    - Display settings changes are staged but not applied until the "Apply" button is pressed.
- **Window Resizing:**
    - The window must be user-resizable.
    - The project must be configured to maintain aspect ratio (stretch mode "canvas_items" or "viewport" with "keep" aspect).
- **Persistence:**
    - Applied settings must be saved using the existing persistence system (implied by `product.md`) so they persist across sessions.

## Non-Functional Requirements
- **UX Polish:** UI should be responsive and provide clear feedback when changes are applied.
- **Engine Best Practices:** Use Godot 4.3+ `DisplayServer` for window management.

## Acceptance Criteria
- [ ] User can select a resolution from a 16:9 list.
- [ ] User can switch between Windowed, Fullscreen, and Borderless Fullscreen.
- [ ] Settings only change on the screen after clicking "Apply".
- [ ] Resizing the window manually preserves the 16:9 aspect ratio (with bars if needed).
- [ ] Settings are saved and restored on game launch.

## Out of Scope
- Custom/Arbitrary resolution input.
- Multi-monitor specific configurations.
- Refresh rate selection.
