extends GutTest

func test_pause_menu_instantiated_on_demand():
	# Ensure we have a scene
	if get_tree().current_scene == null:
		var dummy = Node2D.new()
		dummy.name = "TestScene"
		get_tree().root.add_child(dummy)
		get_tree().current_scene = dummy
	
	var current_scene = get_tree().current_scene
	var menu = current_scene.find_child("PauseMenu", true, false)
	assert_null(menu, "Pause menu should not be in the tree initially")
	
	GameManager.toggle_pause() # Pauses
	assert_true(GameManager.game_paused)
	
	menu = current_scene.find_child("PauseMenu", true, false)
	assert_not_null(menu, "Pause menu should be instantiated and added to tree after toggle_pause")
	
	GameManager.toggle_pause() # Unpauses
	# Wait for animation
	await wait_seconds(0.5)
	
	menu = current_scene.find_child("PauseMenu", true, false)
	assert_null(menu, "Pause menu should be removed from tree and freed after unpausing")
