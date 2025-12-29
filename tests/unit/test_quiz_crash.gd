extends GutTest

var quiz_scene_script = load("res://src/scripts/GameSession.gd")
var quiz_scene_path = "res://src/scenes/quiz_scene.tscn"
var game_session: GameSession
var quiz_scene_instance: Control

func before_each():
	# Reset GameManager
	GameManager.questions_pool = []
	GameManager.reset_stats()
	
	# Load the scene
	var scene = load(quiz_scene_path)
	quiz_scene_instance = scene.instantiate()
	add_child_autofree(quiz_scene_instance)
	game_session = quiz_scene_instance as GameSession

func after_each():
	GameManager.questions_pool = []

func test_crash_scenario_stale_answers_on_invalid_data():
	# Setup: 
	# Question 1: Valid, 2 answers (indices 0, 1 valid)
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
		# Missing answers
	}
	
	GameManager.questions_pool = [q1, q2]
	
	# Manually start game to load Q1
	game_session.start_game()
	
	# Assert Q1 loaded correctly
	assert_eq(game_session.current_q_index, 0, "Should be on Q1")
	assert_eq(game_session.current_shuffled_answers.size(), 2, "Q1 should have 2 answers")
	
	# Force load Q2 (the invalid one)
	# This simulates the transition to the next question
	game_session.load_question(1)
	
	# Check for the VULNERABLE STATE
	# 1. State is PLAYING (input enabled)
	assert_eq(game_session.current_state, GameSession.State.PLAYING, "State should be PLAYING despite invalid Q2")
	
	# 2. Visuals are reset (All 4 buttons visible)
	# We assume the scene has 4 buttons.
	assert_gt(game_session.answer_buttons.size(), 2, "Scene should have more than 2 buttons for this test")
	for btn in game_session.answer_buttons:
		assert_true(btn.visible, "All buttons should be visible due to _reset_button_visuals()")
		
	# 3. Data is STALE (still has Q1's 2 answers)
	assert_eq(game_session.current_shuffled_answers.size(), 2, "Answers array should still have Q1 data (stale)")
	
	# 4. Crash Condition
	# If user clicks button 3 (index 2), it calls _on_button_pressed(2)
	# current_shuffled_answers[2] -> Crash!
	
	var unsafe_button_index = 2
	var would_crash = unsafe_button_index >= game_session.current_shuffled_answers.size()
	assert_true(would_crash, "Clicking button 3 would cause an out-of-bounds crash")
