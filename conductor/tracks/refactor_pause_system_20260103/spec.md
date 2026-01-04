# Specification: Pause System Refactor

## 1. Overview
This track introduces a `GameOverlay` Autoload to handle persistent UI elements (Pause Menu), removing the responsibility from `GameManager`. This fixes the "God Object" anti-pattern and prepares the architecture for better layering.

## 2. Functional Requirements
- **GameOverlay:** A persistent `CanvasLayer` that contains the `PauseMenu` instance (or instantiates it on demand).
- **GameManager:** Manages the *logic* state (`game_paused` bool) but delegates *presentation* to `GameOverlay`.
- **Z-Index:** `GameOverlay` must have a high Layer index (e.g., 100) to appear above game content.

## 3. Acceptance Criteria
- [ ] `GameManager` has no code related to `instantiate()` or `add_child()` for the Pause Menu.
- [ ] Pressing ESC toggles the pause menu flawlessly.
- [ ] Pause menu buttons (Resume, Restart, Quit) function correctly.
