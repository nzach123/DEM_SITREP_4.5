extends GutTest

var main_menu_script = load("res://src/scripts/MainMenu.gd")
var main_menu_instance

const TEST_DIR = "res://assets/questions/"
const VALID_FILE = "test_valid_quiz.json"
const INVALID_FILE = "test_invalid_type.json"

func before_all():
	# Create dummy files for testing
	var file_valid = FileAccess.open(TEST_DIR + VALID_FILE, FileAccess.WRITE)
	file_valid.store_string('{"type": "quiz"}')
	file_valid.close()

	var file_invalid = FileAccess.open(TEST_DIR + INVALID_FILE, FileAccess.WRITE)
	file_invalid.store_string('{"type": "unknown"}')
	file_invalid.close()

func after_all():
	# Clean up dummy files
	var dir = DirAccess.open(TEST_DIR)
	if dir:
		dir.remove(VALID_FILE)
		dir.remove(INVALID_FILE)

func before_each():
	main_menu_instance = main_menu_script.new()
	add_child(main_menu_instance)

func after_each():
	main_menu_instance.free()

func test_scan_valid_course():
	var valid_id = VALID_FILE.replace(".json", "")
	
	# Stub GameManager to return 'quiz' for this file
	stub(GameManager).get_course_type(valid_id).to_return("quiz")
	
	main_menu_instance.scan_courses()
	
	assert_has(main_menu_instance.available_courses, valid_id, "Valid quiz course should be in available_courses")

func test_scan_invalid_course():
	var invalid_id = INVALID_FILE.replace(".json", "")
	
	# Stub GameManager to return 'unknown' for this file
	stub(GameManager).get_course_type(invalid_id).to_return("unknown")
	
	main_menu_instance.scan_courses()
	
	# EXPECTED FAILURE INITIALLY (Current logic is != "matching", so "unknown" is allowed)
	# After fix, this should pass (assert_does_not_have)
	# For TDD (Red Phase), we assert the DESIRED behavior, so this test SHOULD FAIL now.
	assert_does_not_have(main_menu_instance.available_courses, invalid_id, "Invalid/Unknown course should NOT be in available_courses")
