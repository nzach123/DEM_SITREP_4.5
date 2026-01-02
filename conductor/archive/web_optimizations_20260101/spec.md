# Specification - Web Export Optimizations

## Overview
Optimize the Godot 4.5 project for a stable and polished Web (HTML5) deployment, specifically targeting itch.io. This includes UI adjustments, audio context handling, and export configuration.

## Functional Requirements
- **Web-Specific UI Management:**
    - Automatically hide the **Quit Button**, **Resolution Selection**, **Window Mode Toggles**, and **Fullscreen Toggle** when `OS.has_feature("web")` is true.
- **Audio Context Unlock:**
    - Modify the existing Splash Screen to act as a landing page for Web builds.
    - On Web, the Splash Screen must wait for a user interaction (click/touch) before proceeding.
    - Add a "Click to Start" visual cue to the Splash Screen for Web users.
- **Data Persistence (Web):**
    - Ensure `*.json` files are whitelisted in the export settings to maintain the data-driven course loading logic.
- **Engine Configuration:**
    - Set rendering method to `gl_compatibility` for maximum browser support.
    - Enable VRAM compression (ETC2/ASTC) for mobile web compatibility.
    - Disable Thread Support in the Web export preset for itch.io compatibility.

## Non-Functional Requirements
- **Performance:** Ensure the 1080p internal resolution scales smoothly to a 960x540 embed.
- **UX:** Maintain the "Intentional Arcade Minimalism" style.
- **Reliability:** Prevent "AudioContext" blocking and "DirAccess" failures in the virtual filesystem.

## Acceptance Criteria
- [ ] Game builds and runs in a standard browser (Chrome/Firefox/Safari).
- [ ] Courses list is correctly populated from JSON files in the browser.
- [ ] The Splash Screen requires a click to proceed on Web and plays audio immediately after.
- [ ] Web-incompatible UI elements are hidden.
- [ ] **Test Coverage:** Unit tests exist and pass for all new conditional logic (OS feature checks, input handling).
- [ ] **Diagnostics:** Any failure in the export or runtime process is diagnosed with a prescribed fix.

## Out of Scope
- Complete UI redesign for small-screen mobile devices.
- Backend server integration for data persistence.
