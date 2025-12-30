# Implementation Plan: Settings and Credits Scenes

## Phase 1: Settings Management (Core Logic)
- [ ] **Task 1: Create SettingsManager Autoload**
    - [ ] Create `src/autoload/SettingsManager.gd`.
    - [ ] Define default settings dictionary (Display, Audio).
- [ ] **Task 2: Implement ConfigFile Persistence**
    - [ ] Write `save_settings()` to write to `user://settings.cfg`.
    - [ ] Write `load_settings()` to read from `user://settings.cfg`.
- [ ] **Task 3: Implement Settings Application Logic**
    - [ ] Create functions to update Audio buses in real-time.
    - [ ] Create functions to update Display modes (Fullscreen, Windowed, Resizable).
- [ ] **Task 4: Unit Testing - SettingsManager**
    - [ ] Write tests to verify `ConfigFile` read/write.
    - [ ] Write tests to verify settings values are correctly updated in the manager.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Settings Management' (Protocol in workflow.md)

## Phase 2: Settings UI Implementation
- [ ] **Task 1: Create Settings Scene Shell**
    - [ ] Create `src/ui/settings/SettingsMenu.tscn`.
    - [ ] Implement responsive layout using `VBoxContainer` and `HBoxContainer`.
- [ ] **Task 2: Build Audio Controls**
    - [ ] Implement Sliders for Master, Music, and SFX.
    - [ ] Connect slider signals to `SettingsManager`.
- [ ] **Task 3: Build Display Controls**
    - [ ] Implement `OptionButton` for Resolutions.
    - [ ] Implement `CheckButton` for Fullscreen/Borderless.
- [ ] **Task 4: Implement "Apply" and "Back" Logic**
    - [ ] Hook "Apply" to `SettingsManager.save_settings()`.
    - [ ] Hook "Back" to return to previous scene/close modal.
- [ ] **Task 5: Integration - Main Menu and Pause Menu**
    - [ ] Update Main Menu to instance Settings.
    - [ ] Create/Update Pause Menu to instance Settings.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Settings UI' (Protocol in workflow.md)

## Phase 3: Credits Scene Implementation
- [ ] **Task 1: Create Credits Scene**
    - [ ] Create `src/ui/credits/Credits.tscn`.
    - [ ] Setup `ScrollContainer` for the vertical list.
- [ ] **Task 2: Populate Credits Content**
    - [ ] Create a `RichTextLabel` or list of labels with attribution data.
    - [ ] Implement auto-scrolling logic (optional/manual scroll focus).
- [ ] **Task 3: Navigation**
    - [ ] Ensure "Back" button returns to the Main Menu.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Credits Scene' (Protocol in workflow.md)

## Phase 4: Final Polishing and Verification
- [ ] **Task 1: Visual and Audio Feedback**
    - [ ] Add hover/press sounds to all new buttons.
    - [ ] Ensure theme consistency with the rest of the app.
- [ ] **Task 2: Cross-Platform (Web/Desktop) Verification**
    - [ ] Verify window resizing behaves correctly on Windows.
    - [ ] Verify fullscreen toggles work in browser.
- [ ] Task: Conductor - User Manual Verification 'Phase 4: Final Polishing' (Protocol in workflow.md)
