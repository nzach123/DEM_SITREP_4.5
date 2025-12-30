extends GutTest

func after_each():
	GameManager.game_paused = false
	get_tree().paused = false

func test_settings_navigation_logic():
	var pause_menu = load("res://src/scenes/PauseMenu.tscn").instantiate()
	# Add to tree so onready variables are initialized
	add_child_autofree(pause_menu)
	
	var menu_root = pause_menu.get_node("Panel/VBoxContainer")
	var settings_btn = pause_menu.find_child("Settings", true, false)
	
	assert_not_null(settings_btn, "Settings button should exist")
	
	# Simulate pressing settings
	pause_menu.call("_on_settings_pressed")
	
	assert_false(menu_root.visible, "Menu root should be hidden when settings are opened")
	assert_not_null(pause_menu.settings_instance, "Settings instance should be created")
	assert_true(pause_menu.settings_instance.visible, "Settings overlay should be visible")
	
	# Simulate closing settings
	pause_menu.call("_on_settings_closed")
	
	assert_true(menu_root.visible, "Menu root should be visible when settings are closed")
	assert_false(pause_menu.settings_instance.visible, "Settings overlay should be hidden")