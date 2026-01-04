extends GutTest
## Tests for GameOverlay autoload - pause menu lifecycle management

func before_each():
	# Ensure clean state
	GameManager.game_paused = false
	get_tree().paused = false

func after_each():
	if GameManager.game_paused:
		GameManager.toggle_pause()
	await wait_seconds(0.3)

func test_overlay_process_mode_always():
	assert_eq(GameOverlay.process_mode, Node.PROCESS_MODE_ALWAYS, "GameOverlay should always process")

func test_overlay_layer_is_99():
	assert_eq(GameOverlay.layer, 99, "GameOverlay layer should be 99 (below CRT at 100)")

func test_pause_menu_shown_on_pause_signal():
	# Create a dummy scene for testing
	var node = Node2D.new()
	get_tree().root.add_child(node)
	get_tree().current_scene = node

	# Pause
	GameManager.toggle_pause()
	await wait_frames(2)
	
	# Menu should be a child of GameOverlay, not the scene
	var menu = GameOverlay.find_child("PauseMenu", true, false)
	assert_not_null(menu, "Pause menu should be a child of GameOverlay")
	assert_true(menu is Control, "Pause menu should be a Control")

func test_pause_menu_hidden_on_unpause():
	var node = Node2D.new()
	get_tree().root.add_child(node)
	get_tree().current_scene = node

	GameManager.toggle_pause()
	await wait_frames(2)
	
	# Unpause
	GameManager.toggle_pause()
	# Wait for close animation
	await wait_seconds(0.3)
	
	# Menu should be removed (queue_free'd by PauseMenu.close_menu())
	var menu = GameOverlay.find_child("PauseMenu", true, false)
	assert_null(menu, "Pause menu should be removed after unpause")

func test_pause_toggled_signal_emitted():
	var signal_values: Array = []
	GameManager.pause_toggled.connect(func(val): signal_values.append(val))
	
	GameManager.toggle_pause()
	assert_eq(signal_values, [true], "pause_toggled should emit true on pause")
	
	GameManager.toggle_pause()
	assert_eq(signal_values, [true, false], "pause_toggled should emit false on unpause")

func test_resume_triggers_unpause():
	var node = Node2D.new()
	get_tree().root.add_child(node)
	get_tree().current_scene = node

	GameManager.toggle_pause()
	await wait_frames(2)
	
	var menu = GameOverlay.find_child("PauseMenu", true, false)
	assert_not_null(menu, "Menu should exist")
	
	# Simulate resume button press
	menu.resume_requested.emit()
	
	assert_false(GameManager.game_paused, "Game should be unpaused after resume")
