extends Control

# Exported dictionary for category labels
@export var category_names: Dictionary = {
	"1110": "BASIC SAFETY",
	"1120": "PROTOCOL ALPHA",
	"1130": "CONTAINMENT",
	"1140": "CRITICAL RESPONSE"
}

@export var buttons_container: VBoxContainer
@export var difficulty_popup: Control
@export var sfx_click: AudioStreamPlayer

const COURSE_BUTTON_SCENE: PackedScene = preload("res://src/scenes/CourseButton.tscn")

# Helper variable to track available question files
var available_courses: Array[String] = []
var pending_course_id: String = ""

func _ready() -> void:
	# Scan for available question files
	scan_courses()
	create_menu_buttons()

	if difficulty_popup:
		if difficulty_popup.has_signal("difficulty_selected"):
			difficulty_popup.connect("difficulty_selected", _start_quiz_with_difficulty)

func scan_courses() -> void:
	available_courses.clear()
	var dir: DirAccess = DirAccess.open("res://assets/questions/")
	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and file_name.ends_with(".json"):
				var course_id: String = file_name.replace(".json", "")
				# Filter out matching types
				if GameManager.get_course_type(course_id) != "matching":
					available_courses.append(course_id)
			file_name = dir.get_next()
		available_courses.sort() # Ensure consistent order

func create_menu_buttons() -> void:
	if not buttons_container: return

	# Clear existing placeholder buttons
	for child in buttons_container.get_children():
		child.queue_free()

	for course_id in available_courses:
		var btn: Control = COURSE_BUTTON_SCENE.instantiate()
		var display_name: String = course_id
		if category_names.has(course_id):
			display_name = course_id + " - " + str(category_names[course_id])

		# Star Rating Calculation
		var progress = GameManager.player_progress.get(course_id, {})
		var mastery = progress.get("mastery_percent", 0.0)
		var stars = "☆☆☆"
		if mastery >= 80.0:
			stars = "★★★"
		elif mastery >= 50.0:
			stars = "★★☆"
		elif mastery > 0.0:
			stars = "★☆☆"

		display_name += "   " + stars

		if btn.has_method("setup"):
			btn.call("setup", course_id, display_name)

		if btn.has_signal("course_selected"):
			btn.connect("course_selected", _on_category_selected)

		buttons_container.add_child(btn)

func _on_category_selected(course_id: String) -> void:
	if sfx_click: sfx_click.play()
	pending_course_id = course_id

	var type = GameManager.get_course_type(course_id)

	if difficulty_popup and difficulty_popup.has_method("setup"):
		difficulty_popup.setup(type)
	elif difficulty_popup:
		difficulty_popup.show()

# --- NEW POPUP LOGIC ---

func _start_quiz_with_difficulty(difficulty: int) -> void:
	if sfx_click: sfx_click.play()

	# Load Data First to Determine Mode
	if GameManager.load_course_data(pending_course_id):
		# Always start quiz scene as we filtered matching files
		GameManager.set_difficulty(difficulty)
		GameManager.change_scene("res://src/scenes/quiz_scene.tscn")
	else:
		print("Failed to load course: " + pending_course_id)
		if difficulty_popup: difficulty_popup.hide()
