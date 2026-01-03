# Specification: Audio System Overhaul & Adaptive Music

## 1. Overview
This track implements a robust, HTML5-compatible audio system for the Main Menu, Quiz Scene, and After Action Report (AAR). The focus is on seamless looping via import settings (avoiding script-based looping) and adaptive music intensity in the Quiz scene based on the "Public Trust" metric. It also involves cleaning up legacy audio code to strictly use Godot's Audio Buses for volume management.

## 2. Functional Requirements

### 2.1. Global Audio Standards
- **Looping:** All background music (BGM) MUST use Godot's Import Settings (`.import` -> Loop: On) to ensure seamless playback on HTML5. Script-based looping (checking `get_playback_position`) is strictly prohibited.
- **Bus Routing:** All BGM players MUST route to the "Music" bus. All UI/SFX players MUST route to the "SFX" bus.
- **Volume Control:** Individual scripts MUST NOT manually set volume based on settings. They rely entirely on `SettingsManager` manipulating the `AudioServer` bus volumes.

### 2.2. Main Menu & AAR Audio
- **Behavior:** "Fire-and-forget" playback on `_ready()`.
- **Node Structure:**
    - **Main Menu:**
        ```text
        Menu_Audio_Manager (Node)
        ├── MUS_Menu_Loop (AudioStreamPlayer, Bus: Music)
        └── SFX_UI (AudioStreamPlayer, Bus: SFX)
        ```
    - **AAR Screen:**
        ```text
        AAR_Audio_Manager (Node)
        ├── MUS_AAR_Loop (AudioStreamPlayer, Bus: Music)
        └── SFX_UI (AudioStreamPlayer, Bus: SFX)
        ```

### 2.3. Quiz Scene Adaptive Audio
- **Behavior:** "Horizontal Resequencing" (Swapping tracks based on state).
- **Trigger:** Listens for `GameManager.trust_changed` signal.
- **Thresholds:**
    -   **High Intensity:** Trust < 35
    -   **Medium Intensity:** Trust 35 - 74
    -   **Low Intensity:** Trust ≥ 75
- **Transition:** When a threshold is crossed, the current track stops (or fades out quickly), and the new track starts immediately. No layering/synchronization.
- **Node Structure:**
    ```text
    Quiz_Audio_Controller (Node)
    ├── MUS_Intensity_High (AudioStreamPlayer, Bus: Music)
    ├── MUS_Intensity_Med (AudioStreamPlayer, Bus: Music)
    ├── MUS_Intensity_Low (AudioStreamPlayer, Bus: Music)
    └── SFX_Quiz_Events (AudioStreamPlayer, Bus: SFX)
    ```

### 2.4. Legacy Cleanup
- Remove any existing `Timer` nodes or `_process` loops previously used for audio looping or restarting.

## 3. Non-Functional Requirements
- **Platform:** HTML5 Optimized (No gaps in loops).
- **Performance:** Minimal script overhead (Signal-driven only).
- **Code Style:** Strict typing (`class_name`, `void` returns).

## 4. Acceptance Criteria
- [ ] Main Menu BGM loops seamlessly without gaps on Web export (or simulated).
- [ ] AAR Screen plays its specific BGM loop on entry.
- [ ] Quiz BGM changes intensity track when Public Trust crosses 35 and 75 thresholds.
- [ ] Audio players automatically respect Master/Music/SFX volume sliders via Bus routing (verified by changing Settings).
- [ ] No `Timer` or `_process` code exists for audio looping.
- [ ] Unit tests verify the adaptive logic triggers the correct player switch.

## 5. Out of Scope
- Dynamic vertical remixing (synced layers).
- Composition of new audio tracks (using existing assets).
