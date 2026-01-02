extends "res://addons/gut/test.gd"

var MainMenuScript = load("res://src/scripts/MainMenu.gd")
var SettingsOverlayScript = load("res://src/scripts/SettingsOverlay.gd")

var _main_menu
var _settings_overlay

var MenuAudioScript = load("res://src/components/MenuAudio.gd")

func before_each():
	# Mock MainMenu
	_main_menu = MainMenuScript.new()
	var mock_quit = Button.new()
	_main_menu.quit_btn = mock_quit
	_main_menu.add_child(mock_quit)
	
	# Mock AudioManager
	var mock_audio = MenuAudioScript.new()
	mock_audio.name = "AudioManager"
	# We don't need to add a dummy script if we instantiate the real class, 
	# as long as we don't trigger logic that requires further dependencies.
	# MenuAudio.gd likely extends Node and has play_click.
	
	_main_menu.add_child(mock_audio)
	_main_menu.audio = mock_audio 
	
	# Mock SettingsOverlay
	_settings_overlay = SettingsOverlayScript.new()
	
	# Mock DisplaySettings container for SettingsOverlay
	var display_settings = VBoxContainer.new()
	display_settings.name = "DisplaySettings"
	_settings_overlay.display_settings_container = display_settings
	_settings_overlay.add_child(display_settings)

func test_main_menu_hides_quit_on_web():
	if "is_web_mode_override" in _main_menu:
		_main_menu.is_web_mode_override = true
		add_child_autofree(_main_menu) # This triggers _ready
		assert_false(_main_menu.quit_btn.visible, "Quit button should be hidden on Web")
	else:
		fail_test("MainMenu does not support is_web_mode_override yet")

func test_settings_overlay_hides_display_options_on_web():
	if "is_web_mode_override" in _settings_overlay:
		_settings_overlay.is_web_mode_override = true
		add_child_autofree(_settings_overlay) # This triggers _ready
		assert_false(_settings_overlay.display_settings_container.visible, "Display settings container should be hidden on Web")
	else:
		fail_test("SettingsOverlay does not support is_web_mode_override yet")
