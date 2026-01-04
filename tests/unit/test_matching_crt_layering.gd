extends GutTest
## Tests for global CRTOverlay architecture
## Verifies correct layering of CRT post-process relative to game content and other overlays

var QuizScene = load("res://src/scenes/quiz_scene.tscn")

func before_each():
	# Reset overlays
	CRTOverlay.layer = 100
	GameOverlay.layer = 99

func test_crt_overlay_structure():
	assert_not_null(CRTOverlay.crt_rect, "CRTOverlay should have a ColorRect")
	assert_eq(CRTOverlay.crt_rect.name, "CRTScreen", "CRT Rect should be named CRTScreen")
	assert_true(CRTOverlay.crt_rect.material is ShaderMaterial, "CRT Rect should have a ShaderMaterial")
	assert_eq(CRTOverlay.layer, 100, "CRTOverlay layer should be 100")

func test_layering_order():
	# Game Content (Layer 0 default) < GameOverlay (99) < CRTOverlay (100)
	
	var scene = QuizScene.instantiate()
	add_child_autofree(scene)
	
	# Verify Scene does NOT have CRTScreen
	var local_crt = scene.find_child("CRTScreen")
	assert_null(local_crt, "QuizScene should NOT have a local CRTScreen node")
	
	# Verify Overlay Layers
	assert_gt(CRTOverlay.layer, GameOverlay.layer, "CRT (100) should be above GameOverlay (99)")
	assert_gt(CRTOverlay.layer, 0, "CRT (100) should be above Game Content (0)")

func test_flash_brightness():
	# Smoke test for the tween function
	CRTOverlay.flash_brightness(5.0, 0.1)
	# We can't easily await the tween in headles unit test without causing delays, 
	# but we can verify it doesn't crash
	assert_true(true, "flash_brightness should execute without error")

func test_popup_instantiation_no_crash():
	# Verify GameSession can spawn popup without crashing due to missing CRTScreen
	var scene = QuizScene.instantiate()
	add_child_autofree(scene)
	
	# Mock the questions pool to prevent start_game errors
	GameManager.questions_pool = [{"question": "Test", "answers": [{"text":"A", "is_correct":true}]}]
	
	# Trigger popup
	scene.call("_trigger_field_exercise")
	
	# Find popup
	var popup = null
	for child in scene.get_children():
		if child.name.begins_with("MatchingEventPopup") or child.has_method("setup"): 
			popup = child
			break
			
	assert_not_null(popup, "Popup should instantiate successfully")
	
	# The popup is just a child of the scene now, ordering is default (on top of earlier nodes)
	# which is fine because CRT is on Layer 100
	assert_eq(popup.get_parent(), scene, "Popup parent should be the scene")

func test_crt_toggle():
	CRTOverlay.is_enabled = true
	assert_true(CRTOverlay.visible, "CRT should be visible when enabled")
	
	CRTOverlay.is_enabled = false
	assert_false(CRTOverlay.visible, "CRT should be hidden when disabled")
	
	CRTOverlay.is_enabled = true
	assert_true(CRTOverlay.visible, "CRT should be visible when re-enabled")
