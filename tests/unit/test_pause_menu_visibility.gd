extends GutTest

var quiz_scene_path = "res://src/scenes/quiz_scene.tscn"
var pause_menu_path = "res://src/scenes/PauseMenu.tscn"

func after_each():
	if GameManager.pause_menu_instance and GameManager.pause_menu_instance.get_parent():
		GameManager.pause_menu_instance.get_parent().remove_child(GameManager.pause_menu_instance)
	GameManager.game_paused = false
	get_tree().paused = false

func test_pause_menu_instantiated_by_gamemanager():
	assert_not_null(GameManager.pause_menu_instance, "GameManager should hold an instance of the Pause Menu")
	assert_true(GameManager.pause_menu_instance is CanvasLayer, "Pause Menu should be a CanvasLayer (or extend it)")

func test_pause_menu_added_to_tree_on_pause():
	# Simulate a simple scene without CRT
	var node = Node2D.new()
	node.name = "TestScene"
	get_tree().root.add_child(node)
	get_tree().current_scene = node
	
	GameManager.toggle_pause()
	assert_true(GameManager.game_paused, "Game should be paused")
	assert_not_null(GameManager.pause_menu_instance.get_parent(), "Pause Menu should be in the tree")
	
	GameManager.toggle_pause()
	assert_false(GameManager.game_paused, "Game should be unpaused")
	
	node.queue_free()

func test_pause_menu_parented_to_crt_in_quiz_scene():
	var scene = load(quiz_scene_path)
	var game_session = scene.instantiate()
	get_tree().root.add_child(game_session)
	get_tree().current_scene = game_session
	
	GameManager.toggle_pause()
	
	var crt = game_session.find_child("CRTScreen", true, false)
	assert_not_null(crt, "QuizScene should have CRTScreen")
	
	# We expect the pause menu to be a child of CRTScreen
	assert_eq(GameManager.pause_menu_instance.get_parent(), crt, "Pause Menu should be parented to CRTScreen when paused in QuizScene")
	
	# Clean up
	GameManager.toggle_pause()
	game_session.queue_free()

func test_pause_menu_process_mode():
	assert_eq(GameManager.pause_menu_instance.process_mode, Node.PROCESS_MODE_ALWAYS, "Pause Menu process mode should be ALWAYS")