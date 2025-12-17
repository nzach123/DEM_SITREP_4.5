extends GutTest

func test_load_course_data_populates_master_pool():
	# Use existing course file
	var result = GameManager.load_course_data("1110")
	assert_true(result, "load_course_data should return true")
	assert_gt(GameManager.master_questions_pool.size(), 0, "Master pool should not be empty")
	assert_eq(GameManager.questions_pool.size(), GameManager.master_questions_pool.size(), "Session pool should be initialized")

func test_reset_session_pool_creates_copy():
	# Setup manually
	var mock_data = [{"id": 1}, {"id": 2}, {"id": 3}]
	GameManager.master_questions_pool = mock_data.duplicate(true)
	GameManager.reset_session_pool()

	assert_eq(GameManager.questions_pool.size(), 3, "Session pool should match master size")

	# Modify session pool
	GameManager.questions_pool.pop_back()

	assert_eq(GameManager.questions_pool.size(), 2, "Session pool should shrink")
	assert_eq(GameManager.master_questions_pool.size(), 3, "Master pool should remain unchanged")

func test_difficulty_settings():
	GameManager.set_difficulty(GameManager.Difficulty.HIGH)
	var settings = GameManager.get_current_settings()
	assert_eq(settings["question_count"], 75, "High difficulty should have 75 questions")

	GameManager.set_difficulty(GameManager.Difficulty.LOW)
	settings = GameManager.get_current_settings()
	assert_eq(settings["question_count"], 10, "Low difficulty should have 10 questions")
