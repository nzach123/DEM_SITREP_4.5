extends Node

enum Difficulty { LOW, MEDIUM, HIGH }

var current_difficulty: Difficulty = Difficulty.LOW

const DIFFICULTY_CONFIG: Dictionary = {
	Difficulty.LOW: {
		"question_count": 10,
		"time_per_question": 15.0,
		"casualty_penalty": 0,
		"population_range": { "min": 10000, "max": 50000 }
	},
	Difficulty.MEDIUM: {
		"question_count": 25,
		"time_per_question": 12.0,
		"casualty_penalty": 250,
		"population_range": { "min": 100000, "max": 500000 }
	},
	Difficulty.HIGH: {
		"question_count": 75,
		"time_per_question": 10.0,
		"casualty_penalty": 500,
		"population_range": { "min": 500000, "max": 2000000 }
	}
}

# Course Data
var master_questions_pool: Array = []
var questions_pool: Array = []
var matching_pool: Array = []
var current_course_id: String = ""
var is_matching_mode: bool = false
var matching_rounds_count: int = 3 # Default to 3 rounds

# Session Data
var current_score: int = 0
var correct_answers_count: int = 0
var total_population: int = 0
var citizens_saved: int = 0
var casualties_count: int = 0
var rescue_multiplier: float = 1.0

# Stores dictionary of { "question": "", "user_choice": "", "correct_answer": "", "is_correct": bool }
var session_log: Array[Dictionary] = []

# Persistent Data
var player_progress: Dictionary = {}
var save_path: String = "user://savegame.save"

var game_paused: bool = false
var pause_menu_scene: PackedScene = preload("res://src/scenes/PauseMenu.tscn")
var pause_menu_instance: CanvasLayer # PauseMenu script extends Control/CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	load_game()
	load_all_matching_data() # Pre-load matching data

	# New Pause Logic
	pause_menu_instance = pause_menu_scene.instantiate()
	add_child(pause_menu_instance)

	if pause_menu_instance.has_signal("resume_requested"):
		pause_menu_instance.connect("resume_requested", toggle_pause)
	if pause_menu_instance.has_signal("restart_requested"):
		pause_menu_instance.connect("restart_requested", restart_level)
	if pause_menu_instance.has_signal("quit_requested"):
		pause_menu_instance.connect("quit_requested", quit_to_main)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		var current_scene = get_tree().current_scene
		# Prevent pausing in the Main Menu or Splash Screen
		if current_scene.name != "MainMenu" and current_scene.name != "SplashScreen":
			toggle_pause()

func toggle_pause() -> void:
	game_paused = !game_paused
	get_tree().paused = game_paused

	if game_paused:
		if pause_menu_instance.has_method("open_menu"):
			pause_menu_instance.call("open_menu")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		if pause_menu_instance.has_method("close_menu"):
			pause_menu_instance.call("close_menu")

func restart_level() -> void:
	if game_paused:
		toggle_pause() # Unpause first

	# 1. Cover the screen with the lowest resolution (Blocky)
	if SceneTransition.has_method("set_pixel_size"):
		SceneTransition.set_pixel_size(8.0)
	SceneTransition.visible = true
	
	await get_tree().process_frame
	get_tree().reload_current_scene()

	# 2. Wait briefly for load, then play the "Boot Up" sequence
	await get_tree().create_timer(0.1).timeout
	SceneTransition.play_boot_sequence()

func change_scene(path: String) -> void:
# 1. Cover the screen with the lowest resolution (Blocky)
	if SceneTransition.has_method("set_pixel_size"):
		SceneTransition.set_pixel_size(8.0)
	SceneTransition.visible = true
	
	await get_tree().process_frame
	get_tree().change_scene_to_file(path)

	# 2. Wait briefly for load, then play the "Boot Up" sequence
	await get_tree().create_timer(0.1).timeout
	SceneTransition.play_boot_sequence()

func quit_to_main() -> void:
	if game_paused:
		toggle_pause() # Unpause first
	change_scene("res://src/scenes/MainMenu.tscn")

func get_current_settings() -> Dictionary:
	return DIFFICULTY_CONFIG.get(current_difficulty, DIFFICULTY_CONFIG[Difficulty.LOW])

func set_difficulty(tier: Difficulty) -> void:
	current_difficulty = tier

func load_all_matching_data() -> void:
	matching_pool.clear()
	var dir = DirAccess.open("res://assets/questions/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and file_name.ends_with(".json"):
				var full_path = "res://assets/questions/" + file_name
				var file = FileAccess.open(full_path, FileAccess.READ)
				var json_text = file.get_as_text()
				var json = JSON.new()
				if json.parse(json_text) == OK:
					if json.data is Dictionary and json.data.has("definitions"):
						if json.data["definitions"] is Array:
							matching_pool.append_array(json.data["definitions"])
			file_name = dir.get_next()

func load_course_data(course_id: String) -> bool:
	current_course_id = course_id
	var file_path: String = "res://assets/questions/" + course_id + ".json"

	if FileAccess.file_exists(file_path):
		var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
		var json_text: String = file.get_as_text()
		var json: JSON = JSON.new()
		var error: Error = json.parse(json_text)

		if error == OK:
			if json.data is Array and json.data.size() > 0:
				var first_item = json.data[0]
				# Standard Quiz
				if first_item is Dictionary and first_item.has("answers") and first_item["answers"] is Array:
					master_questions_pool = json.data
					reset_session_pool()
					is_matching_mode = false
					return true
			# Removed legacy matching loading here as it's handled by load_all_matching_data

	return false

func reset_session_pool() -> void:
	if master_questions_pool.size() > 0:
		questions_pool = master_questions_pool.duplicate(true)
	else:
		questions_pool = []

func get_course_type(course_id: String) -> String:
	var file_path: String = "res://assets/questions/" + course_id + ".json"
	if FileAccess.file_exists(file_path):
		var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
		var json_text: String = file.get_as_text()
		var json: JSON = JSON.new()
		var error: Error = json.parse(json_text)
		if error == OK:
			if json.data is Dictionary and json.data.has("definitions"):
				return "matching"
			elif json.data is Array:
				return "quiz"
	return "unknown"

func get_matching_round_data() -> Array:
	if matching_pool.is_empty():
		return []

	# Attempt to find 5 items with the same tag
	# 1. Collect all tags
	var tag_counts: Dictionary = {}
	for item in matching_pool:
		if item.has("tags"):
			for tag in item["tags"]:
				tag_counts[tag] = tag_counts.get(tag, 0) + 1

	# 2. Filter tags with >= 5 items
	var valid_tags: Array = []
	for tag in tag_counts:
		if tag_counts[tag] >= 5:
			valid_tags.append(tag)

	var selected_items: Array = []

	if valid_tags.size() > 0:
		var random_tag = valid_tags.pick_random()
		# Pick 5 random items with this tag
		var candidates: Array = []
		for item in matching_pool:
			if item.has("tags") and random_tag in item["tags"]:
				candidates.append(item)

		candidates.shuffle()
		selected_items = candidates.slice(0, 5)
	else:
		# Fallback: Random 5 items
		var pool = matching_pool.duplicate()
		pool.shuffle()
		selected_items = pool.slice(0, 5)

	return selected_items

func reset_stats() -> void:
	current_score = 0
	correct_answers_count = 0
	citizens_saved = 0
	total_population = 0
	casualties_count = 0
	rescue_multiplier = 1.0
	session_log.clear()

func add_correct_answer() -> void:
	correct_answers_count += 1
	# Score calculation deprecated in favor of citizens_saved

func save_game() -> void:
	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		var json_string: String = JSON.stringify(player_progress)
		file.store_string(json_string)
		file.close()

func load_game() -> void:
	if not FileAccess.file_exists(save_path):
		return

	var file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
	if file:
		var json_string: String = file.get_as_text()
		var json: JSON = JSON.new()
		var error: Error = json.parse(json_string)
		if error == OK and json.data is Dictionary:
			player_progress = json.data
		file.close()

func log_attempt(question_text: String, user_choice: String, correct_answer: String, is_correct: bool) -> void:
	session_log.append({
		"question": question_text,
		"user_choice": user_choice,
		"correct_answer": correct_answer,
		"is_correct": is_correct
	})
