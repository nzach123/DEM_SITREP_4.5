extends GutTest

var settings_manager_script = load("res://src/autoload/SettingsManager.gd")
var settings_manager

func before_each():
	settings_manager = settings_manager_script.new()
	add_child_autofree(settings_manager)

func test_is_resolution_supported_exists():
	assert_true(settings_manager.has_method("is_resolution_supported"), "Method is_resolution_supported should exist")

func test_is_resolution_supported_returns_bool():
	if settings_manager.has_method("is_resolution_supported"):
		var result = settings_manager.is_resolution_supported()
		assert_typeof(result, TYPE_BOOL, "Should return a boolean")
