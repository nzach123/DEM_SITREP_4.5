extends GutTest

var quiz_scene_script = load("res://src/scripts/GameSession.gd")
var quiz_scene_path = "res://src/scenes/quiz_scene.tscn"
var game_session: GameSession
var quiz_scene_instance: Control

func before_each():
	# Reset GameManager
	GameManager.master_questions_pool = []
	GameManager.questions_pool = []
	GameManager.reset_stats()
	
	# Pre-populate master pool to prevent debug auto-load in _ready
	# and to ensure reset_session_pool() has data.
	GameManager.master_questions_pool = [{
		"question": "Dummy",
		"answers": [{"text": "A", "is_correct": true}]
	}]
	
	# Load the scene
	var scene = load(quiz_scene_path)
	quiz_scene_instance = scene.instantiate()
	add_child_autofree(quiz_scene_instance)
	game_session = quiz_scene_instance as GameSession

func after_each():
	GameManager.master_questions_pool = []
	GameManager.questions_pool = []

func test_crash_safety_on_invalid_data():
	# Setup: 
	# Question 1: Valid, 2 answers
	var q1 = {
		"question": "Q1",
		"answers": [
			{"text": "A1", "is_correct": true},
			{"text": "A2", "is_correct": false}
		]
	}
	# Question 2: Invalid (missing 'answers' key)
	var q2 = {
		"question": "Q2"
	}
	
	# We set the MASTER pool. start_game() calls reset_session_pool() which copies it.
	GameManager.master_questions_pool = [q1]
	game_session.start_game()
	
	# Assert Q1 loaded correctly
	assert_eq(game_session.current_shuffled_answers.size(), 2, "Q1 should have 2 answers")
	assert_eq(game_session.current_state, GameSession.State.PLAYING, "State should be PLAYING for Q1")
	
	# Now corrupt the active pool for the next step (transition)
	# We simulate what happens if a question in the pool is bad
	GameManager.questions_pool = [q1, q2]
	
	# Force load Q2 (the invalid one) at index 1
	game_session.load_question(1)
	
	# Check for SAFETY
	# 1. State should be LOCKED (to prevent button interaction)
	assert_eq(game_session.current_state, GameSession.State.LOCKED, "State should be LOCKED for invalid data")
	
	# 2. Answers array should be CLEARED (no stale data)
	assert_eq(game_session.current_shuffled_answers.size(), 0, "Answers array should be cleared")
	
	# 3. All buttons should be HIDDEN
	for btn in game_session.answer_buttons:
		assert_false(btn.visible, "Buttons should be hidden for invalid data")
	
	# 4. Feedback label should show error
	assert_true(game_session.feedback_label.visible, "Feedback label should be visible")
	assert_string_contains(game_session.feedback_label.text, "ERROR", "Feedback should contain ERROR")
