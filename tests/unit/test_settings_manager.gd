extends GutTest

func before_each():
	SettingsManager.reset_to_defaults()

func test_default_settings():
	assert_eq(SettingsManager.get_volume("Master"), 1.0, "Default Master volume should be 1.0")
	assert_eq(SettingsManager.get_volume("Music"), 1.0, "Default Music volume should be 1.0")
	assert_eq(SettingsManager.get_volume("SFX"), 1.0, "Default SFX volume should be 1.0")
	assert_eq(SettingsManager.get_window_mode(), DisplayServer.WINDOW_MODE_WINDOWED, "Default window mode should be Windowed")

func test_set_and_get_volume():
	SettingsManager.set_volume("Master", 0.5)
	assert_eq(SettingsManager.get_volume("Master"), 0.5, "Master volume should be updated to 0.5")

func test_save_and_load_settings():
	SettingsManager.set_volume("SFX", 0.25)
	SettingsManager.save_settings()
	
	# Reset in-memory value
	SettingsManager.set_volume("SFX", 1.0)
	
	SettingsManager.load_settings()
	assert_eq(SettingsManager.get_volume("SFX"), 0.25, "Loaded SFX volume should be 0.25")
