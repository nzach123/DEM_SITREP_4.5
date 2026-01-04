extends GutTest
## Unit tests for SessionContext resource.

var _session: SessionContext


func before_each() -> void:
	_session = SessionContext.new()


func after_each() -> void:
	_session = null


func test_initial_values() -> void:
	assert_eq(_session.current_score, 0, "Initial current_score should be 0")
	assert_eq(_session.correct_answers_count, 0, "Initial correct_answers_count should be 0")
	assert_eq(_session.total_population, 0, "Initial total_population should be 0")
	assert_eq(_session.citizens_saved, 0, "Initial citizens_saved should be 0")
	assert_eq(_session.casualties_count, 0, "Initial casualties_count should be 0")
	assert_almost_eq(_session.rescue_multiplier, 1.0, 0.01, "Initial rescue_multiplier should be 1.0")
	assert_eq(_session.session_log.size(), 0, "Initial session_log should be empty")


func test_reset_clears_all_values() -> void:
	# Modify values
	_session.current_score = 100
	_session.correct_answers_count = 5
	_session.total_population = 10000
	_session.citizens_saved = 500
	_session.casualties_count = 10
	_session.rescue_multiplier = 2.5
	_session.session_log.append({"question": "test"})
	
	# Reset
	_session.reset()
	
	# Verify all reset
	assert_eq(_session.current_score, 0, "current_score should be reset to 0")
	assert_eq(_session.correct_answers_count, 0, "correct_answers_count should be reset to 0")
	assert_eq(_session.total_population, 0, "total_population should be reset to 0")
	assert_eq(_session.citizens_saved, 0, "citizens_saved should be reset to 0")
	assert_eq(_session.casualties_count, 0, "casualties_count should be reset to 0")
	assert_almost_eq(_session.rescue_multiplier, 1.0, 0.01, "rescue_multiplier should be reset to 1.0")
	assert_eq(_session.session_log.size(), 0, "session_log should be empty after reset")


func test_add_correct_answer_increments_count() -> void:
	_session.add_correct_answer()
	assert_eq(_session.correct_answers_count, 1)
	
	_session.add_correct_answer()
	_session.add_correct_answer()
	assert_eq(_session.correct_answers_count, 3)


func test_log_attempt_adds_entry() -> void:
	_session.log_attempt("What is 2+2?", "4", "4", true)
	
	assert_eq(_session.session_log.size(), 1)
	var entry: Dictionary = _session.session_log[0]
	assert_eq(entry["question"], "What is 2+2?")
	assert_eq(entry["user_choice"], "4")
	assert_eq(entry["correct_answer"], "4")
	assert_true(entry["is_correct"])


func test_log_attempt_multiple_entries() -> void:
	_session.log_attempt("Q1", "A", "A", true)
	_session.log_attempt("Q2", "B", "C", false)
	
	assert_eq(_session.session_log.size(), 2)
	assert_true(_session.session_log[0]["is_correct"])
	assert_false(_session.session_log[1]["is_correct"])


func test_to_dict_serialization() -> void:
	_session.current_score = 50
	_session.citizens_saved = 1000
	_session.log_attempt("Test Q", "A", "A", true)
	
	var data: Dictionary = _session.to_dict()
	
	assert_eq(data["current_score"], 50)
	assert_eq(data["citizens_saved"], 1000)
	assert_eq(data["session_log"].size(), 1)


func test_from_dict_deserialization() -> void:
	var data: Dictionary = {
		"current_score": 75,
		"correct_answers_count": 3,
		"total_population": 50000,
		"citizens_saved": 2500,
		"casualties_count": 5,
		"rescue_multiplier": 1.5,
		"session_log": [{"question": "loaded", "is_correct": true}]
	}
	
	_session.from_dict(data)
	
	assert_eq(_session.current_score, 75)
	assert_eq(_session.correct_answers_count, 3)
	assert_eq(_session.total_population, 50000)
	assert_eq(_session.citizens_saved, 2500)
	assert_eq(_session.casualties_count, 5)
	assert_almost_eq(_session.rescue_multiplier, 1.5, 0.01)
	assert_eq(_session.session_log.size(), 1)
	assert_eq(_session.session_log[0]["question"], "loaded")


func test_from_dict_handles_missing_keys() -> void:
	var partial_data: Dictionary = {
		"current_score": 10
	}
	
	_session.from_dict(partial_data)
	
	assert_eq(_session.current_score, 10)
	assert_eq(_session.citizens_saved, 0, "Missing key should default to 0")
	assert_almost_eq(_session.rescue_multiplier, 1.0, 0.01, "Missing key should default to 1.0")
