extends GutTest

var settings_overlay

func before_each():
	# Ensure defaults
	SettingsManager.reset_to_defaults()
	
	var scene = load("res://src/scenes/SettingsOverlay.tscn")
	settings_overlay = scene.instantiate()
	add_child_autofree(settings_overlay)

func after_each():
	if is_instance_valid(settings_overlay):
		settings_overlay.free()

func test_apply_updates_settings_manager():
	# 1. Open menu to populate UI
	settings_overlay.open_menu()
	
	# 2. Simulate selecting a different resolution (e.g., index 1 = 1366x768)
	# Check RESOLUTIONS constant in script to be sure of index
	# 0: 1280x720, 1: 1366x768
	var target_res = Vector2i(1366, 768)
	settings_overlay._on_resolution_selected(1)
	
	# 3. Verify SettingsManager NOT updated yet (assuming default is 1280x720)
	# If default was already 1366x768, this test is weak. 
	# Resetting to defaults in before_each ensures 1280x720.
	assert_ne(SettingsManager.get_resolution(), target_res, "Settings should not update before Apply")
	
	# 4. Press Apply
	settings_overlay._on_apply_pressed()
	
	# 5. Verify SettingsManager updated
	assert_eq(SettingsManager.get_resolution(), target_res, "Settings should update after Apply")

func test_cancel_does_not_update():
	# 1. Open
	settings_overlay.open_menu()
	var original_res = SettingsManager.get_resolution() # Should be 1280x720
	
	# 2. Change selection to something else
	settings_overlay._on_resolution_selected(1) # 1366x768
	
	# 3. Cancel (Back)
	settings_overlay._on_back_pressed()
	
	# 4. Verify no change in SettingsManager
	assert_eq(SettingsManager.get_resolution(), original_res, "SettingsManager should not change on Back")
	
	# 5. Verify UI resets on reopen?
	settings_overlay.open_menu()
	# The pending resolution should be reset to current (original)
	assert_eq(settings_overlay._pending_resolution, original_res, "UI pending state should reset on reopen")
