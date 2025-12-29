# Specification: Menu Enhancements (Settings & Credits)

## 1. Goal
Implement high-focus, minimalist overlays for Settings and Credits within the `DEM_SITREP` Main Menu, adhering to the "Sleek Tactical" visual identity and "Arcade Minimalism" design philosophy.

## 2. Requirements

### 2.1 Settings Overlay
- **Audio:** 
    - Master, SFX, and Music volume sliders (0% to 100%).
    - Real-time feedback (SFX plays when slider is adjusted).
- **Display:**
    - Window Mode toggle (Fullscreen vs. Windowed).
- **Persistence:**
    - Save settings to `user://settings.cfg` on change.
    - Load settings on application start via `GameManager`.
- **UI:** 
    - Centered panel overlaying the current scene.
    - "Back" button to close the overlay.

### 2.2 Credits Overlay
- **Content:**
    - List of developers, font credits (Bebas Neue, Rajdhani, Montserrat), and asset attributions.
- **UI:**
    - Scrollable container if content exceeds panel height.
    - Centered panel matching the Settings style.
    - "Back" button to return to the menu.

### 2.3 Visual & Polish
- **Typography:** Bebas Neue (Titles), Rajdhani/Montserrat (Body).
- **Feedback:**
    - Button hover/click SFX.
    - Subtle pulsing/scaling on sliders and buttons.
- **Transitions:** Smooth fade in/out using the existing `SceneTransition` system if applicable, or local `AnimationPlayer` for the overlay popup.

## 3. Technical Constraints
- Godot 4.3 GDScript.
- HTML5 export compatibility (respecting input and resolution).
- Integration with existing `MainMenu.tscn` and `GameManager.gd`.
