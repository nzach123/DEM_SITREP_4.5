extends GutTest

var popup_scene_path = "res://src/scenes/MatchingEventPopup.tscn"
var quiz_scene_path = "res://src/scenes/quiz_scene.tscn"

func test_popup_does_not_have_local_crt():
	var scene = load(popup_scene_path)
	var instance = scene.instantiate()
	add_child_autofree(instance)
	
	var crt = instance.find_child("CRTScreen", true, false)
	assert_null(crt, "MatchingEventPopup should not have its own CRTScreen node (it should use the parent's)")

func test_game_session_spawns_popup_under_crt():
	# Setup GameManager with dummy data to allow triggering field exercise
	GameManager.matching_pool = [
		{"id": "1", "term": "T1", "definition": "D1", "tags": ["test"]},
		{"id": "2", "term": "T2", "definition": "D2", "tags": ["test"]},
		{"id": "3", "term": "T3", "definition": "D3", "tags": ["test"]},
		{"id": "4", "term": "T4", "definition": "D4", "tags": ["test"]},
		{"id": "5", "term": "T5", "definition": "D5", "tags": ["test"]}
	]
	
	var scene = load(quiz_scene_path)
	var game_session = scene.instantiate()
	add_child_autofree(game_session)
	
	# Trigger field exercise
	game_session.call("_trigger_field_exercise")
	
	# Find the popup in the tree
	var crt_screen = game_session.get_node("CRTScreen")
	assert_not_null(crt_screen, "QuizScene should have a CRTScreen")

	var popup = null
	for child in game_session.get_children():
		if child.name.begins_with("MatchingEventPopup"):
			popup = child
			break
	
	assert_not_null(popup, "Popup should be instantiated")
	
	assert_eq(popup.get_parent(), game_session, "Popup should be a child of the QuizScene (GameSession)")
	assert_lt(popup.get_index(), crt_screen.get_index(), "Popup should be drawn BEFORE CRTScreen (lower index)")
