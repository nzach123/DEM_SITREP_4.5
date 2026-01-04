extends GutTest
## Tests for pause menu visibility in the new GameOverlay architecture

func before_each():
	GameManager.game_paused = false
	get_tree().paused = false

func after_each():
	if GameManager.game_paused:
		GameManager.toggle_pause()
	await wait_seconds(0.3)

func test_pause_menu_instantiated_on_demand():
	var node = Node2D.new()
	get_tree().root.add_child(node)
	get_tree().current_scene = node
	
	# Menu should not exist initially in GameOverlay
	var menu = GameOverlay.find_child("PauseMenu", true, false)
	assert_null(menu, "Pause Menu should not exist initially")
	
	GameManager.toggle_pause()
	await wait_frames(2)
	
	menu = GameOverlay.find_child("PauseMenu", true, false)
	assert_not_null(menu, "Pause Menu should be instantiated on pause")
	assert_true(menu is Control, "Pause Menu should be a Control")

func test_pause_menu_process_mode():
	var node = Node2D.new()
	get_tree().root.add_child(node)
	get_tree().current_scene = node
	
	GameManager.toggle_pause()
	await wait_frames(2)
	
	var menu = GameOverlay.find_child("PauseMenu", true, false)
	assert_eq(menu.process_mode, Node.PROCESS_MODE_ALWAYS, "Pause Menu process mode should be ALWAYS")
