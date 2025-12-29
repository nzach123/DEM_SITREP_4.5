# Specification: Pause Menu & Quiz Crash Fix

## 1. Overview
This track addresses two critical needs: implementing a robust "Pause Menu" for the Quiz scene and fixing a crash bug that occurs when selecting an answer. The new Pause Menu will follow the project's "Intentional Arcade Minimalism" design philosophy, providing essential options (Resume, Settings, Quit) and triggering via the Escape key or window focus loss. The crash fix involves investigating and resolving a critical stability issue in the quiz interaction logic.

## 2. Functional Requirements

### 2.1 Pause Menu
- **Trigger:**
    - Pressing the `Escape` key (or a dedicated on-screen pause button, if added).
    - **Auto-Pause:** The game must automatically pause when the window loses focus (e.g., user alt-tabs or clicks outside the game window).
- **Visuals:**
    - The menu must overlay the current Quiz scene.
    - The background (Quiz scene) should be dimmed or blurred to indicate the paused state.
    - UI style must match the "Intentional Arcade Minimalism" aesthetic (Control nodes, Theme resources).
- **Options:**
    - **Resume:** Closes the menu and resumes the quiz timer and gameplay.
    - **Settings:** Opens the existing Settings menu (implemented in previous tracks or as a reused scene) to adjust volume, display, etc.
    - **Quit to Menu:** Exits the quiz and returns the user to the Main Menu scene.
- **State Management:**
    - Pausing must stop the quiz timer.
    - Pausing must disable interaction with the underlying quiz questions to prevent accidental clicks.

### 2.2 Bug Fix: Quiz Crash
- **Issue:** The application crashes occasionally when an answer is selected.
- **Goal:** Identify the root cause (likely a null reference, signal connection issue, or array out-of-bounds error) and implement a fix.
- **Verification:** Ensure the crash no longer occurs after repeated testing of answer selection.

## 3. Non-Functional Requirements
- **Stability:** The crash fix must be robust and not introduce new regressions.
- **Performance:** The pause overlay should use lightweight transparency/blur effects suitable for HTML5 exports.
- **Consistency:** The Pause Menu UI must use the existing `Theme` and font assets (Bebas Neue, Rajdhani, etc.).

## 4. Acceptance Criteria
- [ ] Pressing `Escape` toggles the Pause Menu on/off.
- [ ] Clicking outside the game window (focus loss) automatically pauses the game.
- [ ] The quiz timer stops when paused and resumes correctly.
- [ ] "Settings" button opens the settings menu and changes are applied.
- [ ] "Quit" button returns to the Main Menu.
- [ ] Selecting an answer in the Quiz scene no longer causes a crash (verified with 20+ attempts).
- [ ] UI matches the established visual style.
