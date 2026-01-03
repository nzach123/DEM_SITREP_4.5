extends GutTest

var QuizScene = load("res://src/scenes/quiz_scene.tscn")
var GameSessionScript = load("res://src/scripts/GameSession.gd")

func test_popup_is_behind_crt_screen():
	# Instantiate the scene
	var scene = QuizScene.instantiate()
	add_child_autofree(scene)
	
	# Get references
	var crt = scene.find_child("CRTScreen")
	assert_not_null(crt, "CRTScreen should exist")
	
	# Trigger the popup logic
	# We need to access the script instance. 'scene' is the root Control with the script attached.
	# We can call the private method _trigger_field_exercise if we use call() or make it public.
	# It's private, so let's use call() if permitted, or simulate the condition.
	# Simulating rng is hard. Let's call the method directly using call().
	
	scene.call("_trigger_field_exercise")
	
	# Find the popup
	# It's an instance of MATCHING_POPUP_SCENE (MatchingEventPopup)
	# We don't have a direct reference easily unless we search for it.
	var popup = null
	for child in scene.get_children():
		if child.name.begins_with("MatchingEventPopup") or child.has_method("setup"): 
			# Heuristic to find the popup
			popup = child
			break
			
	# Also check children of CRT if the bug is present
	if not popup:
		for child in crt.get_children():
			if child.name.begins_with("MatchingEventPopup") or child.has_method("setup"):
				popup = child
				break
	
	assert_not_null(popup, "Popup should be instantiated")
	
	if popup:
		# Verify hierarchy
		var popup_parent = popup.get_parent()
		assert_eq(popup_parent, scene, "Popup parent should be the scene root, NOT the CRTScreen")
		assert_ne(popup_parent, crt, "Popup should NOT be a child of CRTScreen")
		
		if popup_parent == scene:
			var popup_index = popup.get_index()
			var crt_index = crt.get_index()
			assert_lt(popup_index, crt_index, "Popup index should be less than CRTScreen index (drawn behind)")
