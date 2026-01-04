extends GutTest

## Test Doubles for GameManager
## Verifies that we can inject a mock SceneTransition into the GameManager

class MockSceneTransition:
	extends Node
	
	signal transition_halfway
	
	var cover_called = false
	var boot_called = false
	
	func cover_screen() -> void:
		cover_called = true
		# Emit immediately for test speed
		transition_halfway.emit()
		
	func play_boot_sequence() -> void:
		boot_called = true

func before_each():
	# Ensure clean state
	pass

func after_each():
	# Restore real dependency!
	GameManager.scene_transition_provider = SceneTransition

func test_restart_level_uses_provider():
	var mock = MockSceneTransition.new()
	GameManager.scene_transition_provider = mock
	
	# Stub the scene reload to avoid actual scene changes in this specific unit test
	# Note: get_tree().reload_current_scene() is hard to double without engine-level mocks
	# For this test, we accept the side effect or we'd need to wrap get_tree() too.
	# Since reload_current_scene() might fail in a unit test environment without a current scene,
	# let's set a dummy current scene.
	var node = Node2D.new()
	get_tree().root.add_child(node)
	get_tree().current_scene = node
	
	await GameManager.restart_level()
	
	assert_true(mock.cover_called, "Should call cover_screen on the provider")
	assert_true(mock.boot_called, "Should call play_boot_sequence on the provider")
	
	node.queue_free()

func test_change_scene_uses_provider():
	var mock = MockSceneTransition.new()
	GameManager.scene_transition_provider = mock
	
	# Stub change_scene_to_file. Again, hard to mock global tree functions fully.
	# But we can verify the surrounding logic (the transition wrapper).
	# Ideally, we'd double the whole TreeInteraction, but that's Phase 6+.
	
	# For now, if we call change_scene with a dummy path, it might error if file not found.
	# However, we can assert calls happened before that or catch it?
	# Actually, change_scene_to_file is deferred usually. 
	# Let's just try with a valid path to be safe, like the main menu.
	
	await GameManager.change_scene("res://src/scenes/MainMenu.tscn")
	
	assert_true(mock.cover_called, "Should call cover_screen")
	assert_true(mock.boot_called, "Should call play_boot_sequence")
