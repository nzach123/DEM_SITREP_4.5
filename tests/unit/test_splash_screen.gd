extends "res://addons/gut/test.gd"

var SplashScreenScript = load("res://src/scripts/splash_screen.gd")
var _splash

func before_each():
	_splash = SplashScreenScript.new()
	var mock_rect = TextureRect.new()
	_splash.splash_screen = mock_rect
	_splash.add_child(mock_rect)
	add_child_autofree(_splash)

func test_web_mode_waits_for_input():
	if _splash.get("is_waiting_for_web_input") != null:
		_splash.set("is_web_mode_override", true)
		# We'll skip the actual animation delay for the test
		_splash._prompt_web_click()
		assert_true(_splash.get("is_waiting_for_web_input"), "Should be waiting for web input when in web mode")
	else:
		fail_test("is_waiting_for_web_input property not implemented yet")

func test_input_triggers_transition():
	if _splash.get("is_waiting_for_web_input") != null:
		_splash.set("is_web_mode_override", true)
		var event = InputEventMouseButton.new()
		event.pressed = true
		_splash._unhandled_input(event)
		assert_true(_splash.get("_is_changing_scene"), "Should trigger scene change on input")
	else:
		fail_test("is_waiting_for_web_input property not implemented yet")
