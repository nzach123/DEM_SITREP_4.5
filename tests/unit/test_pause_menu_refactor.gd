extends GutTest

var PauseMenuScene = preload("res://src/scenes/PauseMenu.tscn")
var _pause_menu = null

func before_each():
	_pause_menu = PauseMenuScene.instantiate()
	add_child(_pause_menu)

func after_each():
	_pause_menu.free()

func test_required_buttons_exist():
	var buttons = {
		"Continue": ["Continue", "Resume"],
		"Restart": ["Restart"],
		"Settings": ["Settings"],
		"MainMenu": ["Main Menu", "MainMenu", "Quit"],
		"Quit": ["Quit", "Exit"]
	}
	
	# Specifically checking for the NEW expected names in the refactored menu
	var expected_names = ["Continue", "Restart", "Settings", "MainMenu", "Quit"]
	
	for name in expected_names:
		var btn = _pause_menu.find_child(name, true, false)
		assert_not_null(btn, "Button '" + name + "' should exist in Pause Menu")

func test_signal_methods_exist():
	var expected_methods = [
		"_on_continue_pressed",
		"_on_restart_pressed",
		"_on_settings_pressed",
		"_on_main_menu_pressed",
		"_on_quit_pressed"
	]
	
	for method in expected_methods:
		assert_true(_pause_menu.has_method(method), "Pause Menu should have method: " + method)
