# Plan - Web Export Optimizations

## Phase 1: Project & Export Configuration [checkpoint: 3e84103]
This phase focuses on the "static" configuration changes required for Web compatibility.
- [x] Task: Update `project.godot` Rendering Settings d596e50
    - Set `rendering/renderer/rendering_method` to `gl_compatibility`.
    - Set `rendering/renderer/rendering_method.mobile` to `gl_compatibility`.
    - Enable `rendering/textures/vram_compression/import_etc2_astc`.
- [x] Task: Update `export_presets.cfg` for Web d596e50
    - **Note:** If `export_presets.cfg` does not exist, create a basic Web preset.
    - Set `html/custom_html_shell` (if applicable) or default.
    - **Critical:** Add `*.json` to `include_filter` (Resources > Filters to export non-resource files).
    - Disable `html/threads_support` (Set to `false`).
- [x] Task: Conductor - User Manual Verification 'Project & Export Configuration' (Protocol in workflow.md)

## Phase 2: Splash Screen Logic (TDD)
Implement the "Click to Start" requirement for Web builds to handle AudioContext unlocking.
- [ ] Task: Create Unit Tests for Splash Screen Web Logic
    - Create `tests/unit/test_splash_screen.gd`.
    - Test Case: Verify `splash_finished` signal is *not* emitted automatically when `OS.has_feature("web")` is simulated.
    - Test Case: Verify `splash_finished` is emitted after input action on Web.
- [ ] Task: Implement Web Input Handling in Splash Screen
    - Modify Splash Screen script to check `OS.has_feature("web")`.
    - Add "Click to Start" Label (Control node) that is visible only on Web.
    - Intercept the timer/finish logic to wait for `_input` event on Web.
- [ ] Task: Conductor - User Manual Verification 'Splash Screen Logic (TDD)' (Protocol in workflow.md)

## Phase 3: Main Menu Optimizations (TDD)
Hide incompatible UI elements when running in a browser.
- [ ] Task: Create Unit Tests for Main Menu UI
    - Create `tests/unit/test_main_menu_web.gd`.
    - Test Case: Verify `quit_button`, `resolution_options`, and `window_mode_options` are hidden (visible = false) when `OS.has_feature("web")` is simulated.
- [ ] Task: Implement UI Hiding Logic
    - Modify `MainMenu.gd` (or relevant UI controller).
    - In `_ready()`, add the `OS.has_feature("web")` check to hide the target nodes.
- [ ] Task: Conductor - User Manual Verification 'Main Menu Optimizations (TDD)' (Protocol in workflow.md)

## Phase 4: Final Verification
- [ ] Task: Perform Local Web Export
    - Run the export command to a temporary `build/web` directory.
    - Verify `*.json` files are present in the pck (or accessible).
- [ ] Task: Conductor - User Manual Verification 'Final Verification' (Protocol in workflow.md)
