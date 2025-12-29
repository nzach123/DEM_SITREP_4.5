extends GutTest

var settings_manager_script = load("res://src/autoload/SettingsManager.gd")
var settings_manager

func before_each():
	settings_manager = settings_manager_script.new()
	add_child_autofree(settings_manager)
	# Mock the ConfigFile logic if possible, or just test logic knowing it hits disk (user:// is safe/isolated)
	# ideally we mock, but for simplicity in this environment we'll trust the logic and maybe reset defaults
	settings_manager.reset_to_defaults()

func after_each():
	settings_manager.free()

func test_default_values():
	assert_eq(settings_manager.get_volume("Master"), 1.0, "Master volume should default to 1.0")
	assert_eq(settings_manager.get_window_mode(), DisplayServer.WINDOW_MODE_WINDOWED, "Window mode should default to WINDOWED")

func test_set_get_volume():
	settings_manager.set_volume("Master", 0.5)
	assert_eq(settings_manager.get_volume("Master"), 0.5, "Volume should be updated to 0.5")
	
	settings_manager.set_volume("Master", 1.5)
	assert_eq(settings_manager.get_volume("Master"), 1.0, "Volume should be clamped to 1.0")

	settings_manager.set_volume("Master", -0.5)
	assert_eq(settings_manager.get_volume("Master"), 0.0, "Volume should be clamped to 0.0")

func test_set_window_mode():
	settings_manager.set_window_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	assert_eq(settings_manager.get_window_mode(), DisplayServer.WINDOW_MODE_FULLSCREEN, "Window mode should update to FULLSCREEN")

func test_persistence():
	# 1. Change settings
	settings_manager.set_volume("Music", 0.3)
	settings_manager.save_settings()
	
	# 2. Re-instantiate to simulate restart
	var new_manager = settings_manager_script.new()
	add_child_autofree(new_manager)
	new_manager.load_settings()
	
	assert_eq(new_manager.get_volume("Music"), 0.3, "Persisted volume should be 0.3")
	
	new_manager.free()
