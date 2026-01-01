extends Node

"""
ProfileManager.gd
Manages player progression persistence for the 'Shift Work' system.
Stores current question index, seed, and difficulty for each course.
"""

const SAVE_PATH = "user://profile.dat"

# Dictionary format:
# {
#   "course_id": {
#       "index": int,        # The index of the NEXT question to answer
#       "seed": int,         # The RNG seed used for the session
#       "difficulty": int,   # The difficulty tier selected (0=Low, 1=Med, 2=High)
#       "total_questions": int # Cached total count for UI
#   }
# }
var _user_data: Dictionary = {}

func _ready() -> void:
	load_data()

func save_progress(course_id: String, index: int, rng_seed: int, difficulty: int, total_questions: int) -> void:
	_user_data[course_id] = {
		"index": index,
		"seed": rng_seed,
		"difficulty": difficulty,
		"total_questions": total_questions
	}
	_save_to_disk()

func get_progress(course_id: String) -> Dictionary:
	return _user_data.get(course_id, {})

func has_progress(course_id: String) -> bool:
	return _user_data.has(course_id)

func clear_progress(course_id: String) -> void:
	if _user_data.has(course_id):
		_user_data.erase(course_id)
		_save_to_disk()

func _save_to_disk() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(_user_data)
		file.close()

func load_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var data = file.get_var()
		if data is Dictionary:
			_user_data = data
		file.close()
