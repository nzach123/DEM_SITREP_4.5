# Specification: Settings and Credits Scenes

## Overview
Implementation of a robust Settings system (accessible via Main Menu and Pause Menu) and a dedicated Credits scene. This track focuses on display configuration, audio persistence, and proper attribution, following the "Intentional Arcade Minimalism" design philosophy.

## Functional Requirements

### Settings System
- **Accessibility:** Must be accessible from both the Main Menu and a Pause Menu (in-game).
- **Display Options:**
    - Toggle between Windowed and Fullscreen modes.
    - Support for Borderless Fullscreen.
    - Resolution preset selection (e.g., 1920x1080, 1280x720).
    - Draggable window resizing in Windowed mode.
- **Audio Control:**
    - Sliders for Master, Music, and SFX buses.
- **Persistence:**
    - Settings must be saved/loaded using Godot's `ConfigFile` system (`user://settings.cfg`).
    - An "Apply" button must be used to commit and save changes.
- **Mobile Readiness:** UI layout must be responsive to accommodate future mobile deployment.

### Credits Scene
- **Content:** Simple vertically scrolling list.
- **Sections:** Attribution for Development, Assets (Fonts, SFX, Music), and Special Thanks.
- **Navigation:** Clear "Back" button to return to the calling scene.

## Non-Functional Requirements
- **Performance:** UI operations must not cause frame drops.
- **UX:** Immediate visual/audio feedback on UI interactions.
- **Style:** Adherence to the project's arcade minimalism (bold hierarchy, clear typography).

## Acceptance Criteria
- [ ] Settings can be opened and closed from Main Menu.
- [ ] Settings can be opened and closed from a Pause Menu during gameplay.
- [ ] Window mode changes (Fullscreen/Windowed) persist after clicking "Apply" and restarting.
- [ ] Volume sliders correctly adjust audio buses.
- [ ] Credits scroll smoothly and return to the Main Menu when finished or exited.
- [ ] All settings data is correctly written to and read from `settings.cfg`.

## Out of Scope
- Advanced graphical settings (Shadow quality, SSAO, etc.).
- Complex key rebinding (initially).
