extends GutTest

var quiz_scene_path = "res://src/scenes/quiz_scene.tscn"

func before_each():
	# Ensure a clean state for each test
	if get_tree().current_scene:
		get_tree().current_scene.free()
		get_tree().current_scene = null
	GameManager.game_paused = false
	get_tree().paused = false

func after_each():
	if GameManager.game_paused:
		GameManager.toggle_pause()
	# Wait for cleanup
	await wait_seconds(0.1)

func test_pause_menu_instantiated_on_demand():
	var node = Node2D.new()
	get_tree().root.add_child(node)
	get_tree().current_scene = node
	
	var menu = get_tree().root.find_child("PauseMenu", true, false)
	assert_null(menu, "Pause Menu should not exist initially")
	
	GameManager.toggle_pause()
	menu = get_tree().root.find_child("PauseMenu", true, false)
	assert_not_null(menu, "GameManager should instantiate the Pause Menu on pause")
	assert_true(menu is Control, "Pause Menu should be a Control (or extend it)")

func test_pause_menu_added_to_tree_on_pause():
	var node = Node2D.new()
	node.name = "TestScene"
	get_tree().root.add_child(node)
	get_tree().current_scene = node
	
	GameManager.toggle_pause()
	assert_true(GameManager.game_paused, "Game should be paused")
	
	var menu = get_tree().root.find_child("PauseMenu", true, false)
	assert_not_null(menu, "Pause Menu should be in the tree")
	assert_eq(menu.get_parent().name, "TestScene", "Pause Menu should be a child of the current scene")
	
	GameManager.toggle_pause()
	assert_false(GameManager.game_paused, "Game should be unpaused")

func test_pause_menu_positioned_before_crt_in_quiz_scene():
	var scene = load(quiz_scene_path)
	var quiz = scene.instantiate()
	get_tree().root.add_child(quiz)
	get_tree().current_scene = quiz
	
	GameManager.toggle_pause()
	
	var crt = quiz.find_child("CRTScreen", true, false)
	assert_not_null(crt, "QuizScene should have CRTScreen")
	
	var menu = get_tree().root.find_child("PauseMenu", true, false)
	# We expect the pause menu to be a sibling of CRTScreen and at an index lower than CRT
	assert_eq(menu.get_parent(), quiz, "Pause Menu should be a child of the scene root")
	assert_true(menu.get_index() < crt.get_index(), "Pause Menu should be positioned before CRTScreen in the tree")

func test_pause_menu_process_mode():
	var node = Node2D.new()
	get_tree().root.add_child(node)
	get_tree().current_scene = node
	
	GameManager.toggle_pause()
	var menu = get_tree().root.find_child("PauseMenu", true, false)
	assert_eq(menu.process_mode, Node.PROCESS_MODE_ALWAYS, "Pause Menu process mode should be ALWAYS")
