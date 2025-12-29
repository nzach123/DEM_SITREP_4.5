# Implementation Plan: Display Settings Enhancements

## Phase 1: Core Logic (SettingsManager) [checkpoint: 59c03a8]
- [x] **Task 1: Update SettingsManager with new display settings**
    - Add `resolution` to display settings dictionary.
    - Update `set_window_mode` to optionally NOT apply immediately (or add a separate staged update method).
    - Add `set_resolution(resolution: Vector2i)` method.
    - Update `_apply_display_settings` to handle both mode and resolution.
- [x] **Task 2: Implement persistence for new settings**
    - Ensure `resolution` is saved and loaded from `settings.cfg`.
- [x] **Task 3: Unit Testing - SettingsManager Updates**
    - Write tests for `set_resolution` and `set_window_mode`.
    - Verify persistence of these new values.
- [x] Task: Conductor - User Manual Verification 'Phase 1: Core Logic' (Protocol in workflow.md)

## Phase 2: UI Implementation (SettingsOverlay) [checkpoint: 456d7c0]
- [x] **Task 1: Update SettingsOverlay.tscn layout**
    - Add `OptionButton` for Resolution (populated with 16:9 list).
    - Add `OptionButton` for Window Mode (Windowed, Fullscreen, Borderless).
    - Add "Apply" `Button`.
- [x] **Task 2: Update SettingsOverlay.gd logic**
    - Connect signals from new controls.
    - Implement staging logic: selections are stored locally until "Apply" is pressed.
    - Update "Apply" button to call `SettingsManager` to apply and save changes.
    - Initialize UI with current settings from `SettingsManager`.
- [x] **Task 3: Unit Testing - UI Integration**
    - Write tests to verify UI interaction correctly calls `SettingsManager` only when "Apply" is pressed.
- [x] Task: Conductor - User Manual Verification 'Phase 2: UI Implementation' (Protocol in workflow.md)

## Phase 3: Project Configuration & Polish
- [ ] **Task 1: Configure Project Settings for Resizing**
    - Set `display/window/size/resizable` to true.
    - Set `display/window/stretch/mode` to `canvas_items`.
    - Set `display/window/stretch/aspect` to `keep`.
- [ ] **Task 2: Final Integration Test**
    - Verify end-to-end flow: Open menu -> Change resolution/mode -> Apply -> Verify window change.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Project Configuration & Polish' (Protocol in workflow.md)
