extends GutTest

func after_each():
	if GameManager.pause_menu_instance and GameManager.pause_menu_instance.get_parent():
		GameManager.pause_menu_instance.get_parent().remove_child(GameManager.pause_menu_instance)
	GameManager.game_paused = false
	get_tree().paused = false

func test_settings_navigation_logic():
	var pause_menu = GameManager.pause_menu_instance
	# Add to tree so onready variables are initialized
	get_tree().root.add_child(pause_menu)
	
	var menu_root = pause_menu.get_node("CenterContainer/MenuRoot")
	var settings_btn = pause_menu.find_child("Settings", true, false)
	if not settings_btn:
		settings_btn = pause_menu.find_child("Options", true, false) # Fallback for initial test
	
	assert_not_null(settings_btn, "Settings/Options button should exist")
	
	# Simulate pressing settings
	pause_menu.call("_on_settings_pressed")
	
	assert_false(menu_root.visible, "Menu root should be hidden when settings are opened")
	assert_not_null(pause_menu.settings_instance, "Settings instance should be created")
	assert_true(pause_menu.settings_instance.visible, "Settings overlay should be visible")
	
	# Simulate closing settings
	pause_menu.call("_on_settings_closed")
	
	assert_true(menu_root.visible, "Menu root should be visible when settings are closed")
	assert_false(pause_menu.settings_instance.visible, "Settings overlay should be hidden")
