extends GutTest

var PauseMenuScript = load("res://src/scripts/PauseMenu.gd")
var pause_menu_scene = load("res://src/scenes/PauseMenu.tscn")

func test_resume_flow_clean():
	var menu = pause_menu_scene.instantiate()
	add_child(menu)

	# Track signal emission
	var resume_signal_fired = false
	menu.resume_requested.connect(func(): resume_signal_fired = true)

	# Mock the button press
	menu._on_continue_pressed()
	
	# Verify IMMEDIATE signal emission (no delay)
	assert_true(resume_signal_fired, "Signal should fire IMMEDIATELY upon press")
	
	# Verify menu is NOT killing itself yet
	assert_false(menu.is_queued_for_deletion(), "Menu should wait for GameManager to dismiss it")
	
	# Verify close_menu triggers cleanup
	menu.close_menu()

	# Wait for animation (0.2s)
	await wait_seconds(0.3)

	# Verify cleanup
	assert_true(menu.is_queued_for_deletion(), "Menu should be freeing after close_menu completes")

func test_close_menu_is_idempotent():
	var menu = pause_menu_scene.instantiate()
	add_child(menu)
	
	menu.close_menu()
	menu.close_menu() # Second call
	
	# Should not crash and should still free
	await wait_seconds(0.3)
	assert_true(menu.is_queued_for_deletion())
