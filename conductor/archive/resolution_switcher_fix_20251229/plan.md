# Plan: Resolution Switcher Fix

## Phase 1: Environment Detection & Safety Logic
- [x] Task: Implement environment detection in `SettingsManager`.
    - Write a test in `tests/unit/test_display_settings_logic.gd` to verify a new `is_resolution_supported()` method.
    - Implement `is_resolution_supported()` in `src/autoload/SettingsManager.gd` using `OS.has_feature("editor")` and checking if the window is embedded.
- [x] Task: Update `SettingsManager.set_resolution()` to respect the support check.
    - Write a test to ensure `set_resolution()` does not call `DisplayServer` if unsupported.
    - Update `src/autoload/SettingsManager.gd` with the check.

## Phase 2: UI Integration & Feedback
- [x] Task: Update `SettingsOverlay` UI state based on support.
    - Write a test in `tests/unit/test_settings_overlay_integration.gd` to verify the resolution dropdown is disabled in the editor.
    - Implement the logic in `src/scripts/SettingsOverlay.gd` to disable `resolution_option` and set the tooltip if `SettingsManager.is_resolution_supported()` returns false.
- [x] Task: Conductor - User Manual Verification 'Phase 2' (Protocol in workflow.md)

[checkpoint: 2835902]
