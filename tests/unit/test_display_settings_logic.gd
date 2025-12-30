extends GutTest

var settings_manager_script = load("res://src/autoload/SettingsManager.gd")
var settings_manager

func before_each():
	settings_manager = settings_manager_script.new()
	add_child_autofree(settings_manager)
	settings_manager.reset_to_defaults()

func after_each():
	if is_instance_valid(settings_manager):
		settings_manager.free()

func test_default_resolution():
	# Default resolution should be 1280x720 (standard 16:9)
	assert_eq(settings_manager.get_resolution(), Vector2i(1280, 720), "Default resolution should be 1280x720")

func test_set_get_resolution():
	var new_res = Vector2i(1920, 1080)
	settings_manager.set_resolution(new_res)
	assert_eq(settings_manager.get_resolution(), new_res, "Resolution should be updated to 1920x1080")

func test_resolution_persistence():
	var test_res = Vector2i(1600, 900)
	settings_manager.set_resolution(test_res)
	settings_manager.save_settings()
	
	var new_manager = settings_manager_script.new()
	add_child_autofree(new_manager)
	new_manager.load_settings()
	
	assert_eq(new_manager.get_resolution(), test_res, "Persisted resolution should be 1600x900")
	new_manager.free()

func test_apply_display_settings():
	var test_mode = DisplayServer.WINDOW_MODE_FULLSCREEN
	var test_res = Vector2i(1920, 1080)
	
	settings_manager.set_window_mode(test_mode)
	settings_manager.set_resolution(test_res)
	
	assert_eq(settings_manager.get_window_mode(), test_mode)
	assert_eq(settings_manager.get_resolution(), test_res)
