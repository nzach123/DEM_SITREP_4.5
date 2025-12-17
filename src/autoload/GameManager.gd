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
var current_course_id: String = ""

# Session Data
var current_score: int = 0
var correct_answers_count: int = 0
var total_population: int = 0
var citizens_saved: int = 0
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

	SceneTransition.cover()
	await get_tree().process_frame
	get_tree().reload_current_scene()

	# Wait for load, then resolve
	await get_tree().create_timer(0.1).timeout
	SceneTransition.resolve()

func change_scene(path: String) -> void:
	SceneTransition.cover()
	await get_tree().process_frame
	get_tree().change_scene_to_file(path)

	# Wait for load, then resolve
	await get_tree().create_timer(0.1).timeout
	SceneTransition.resolve()

func quit_to_main() -> void:
	if game_paused:
		toggle_pause() # Unpause first
	change_scene("res://src/scenes/MainMenu.tscn")

func get_current_settings() -> Dictionary:
	return DIFFICULTY_CONFIG.get(current_difficulty, DIFFICULTY_CONFIG[Difficulty.LOW])

func set_difficulty(tier: Difficulty) -> void:
	current_difficulty = tier

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
				if first_item is Dictionary and first_item.has("answers") and first_item["answers"] is Array:
					master_questions_pool = json.data
					reset_session_pool()
					return true

			print("Error: Loaded data does not match expected schema.")
			return false

	return false

func reset_session_pool() -> void:
	if master_questions_pool.size() > 0:
		questions_pool = master_questions_pool.duplicate(true)
	else:
		questions_pool = []

func reset_stats() -> void:
	current_score = 0
	correct_answers_count = 0
	citizens_saved = 0
	total_population = 0
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
