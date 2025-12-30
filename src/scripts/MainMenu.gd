extends Control

# Exported dictionary for category labels
@export var category_names: Dictionary = {
	"1110": "Individual Resilience and Human Behaviour in Disasters",
	"1120": "Disaster and Emergency Management as a Field of Practice",
	"1130": "Disaster Risk Reduction (DRR)",
	"1140": "Disaster and Emergency Management Related Legislation, Standards, and Stakeholders"
}

@export var buttons_container: GridContainer
@export var difficulty_popup: Control
@export var settings_overlay: Control
@export var credits_overlay: Control
@export var sfx_click: AudioStreamPlayer

# Footer Buttons
@export var settings_btn: Button
@export var credits_btn: Button
@export var quit_btn: Button

const COURSE_CARD_SCENE: PackedScene = preload("res://src/scenes/CourseCard.tscn")

var available_courses: Array[String] = []
var pending_course_id: String = ""

func _ready() -> void:
	add_to_group("main_menu")
	# Scan for available question files
	scan_courses()
	create_menu_buttons()

	if difficulty_popup:
		if difficulty_popup.has_signal("difficulty_selected"):
			difficulty_popup.connect("difficulty_selected", _start_quiz_with_difficulty)

	if settings_overlay and settings_overlay.has_signal("close_requested"):
		settings_overlay.close_requested.connect(_on_settings_closed)
	
	if credits_overlay and credits_overlay.has_signal("close_requested"):
		credits_overlay.close_requested.connect(_on_credits_closed)

	connect_footer_buttons()

	# Initial focus for controller/keyboard accessibility
	if buttons_container and buttons_container.get_child_count() > 0:
		buttons_container.get_child(0).call_deferred("grab_focus")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): # Esc
		_on_quit_pressed()

	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F1:
			_on_settings_pressed()
		elif event.keycode == KEY_F2:
			_on_credits_pressed()

func connect_footer_buttons() -> void:
	if settings_btn:
		settings_btn.pressed.connect(_on_settings_pressed)
	if credits_btn:
		credits_btn.pressed.connect(_on_credits_pressed)
	if quit_btn:
		quit_btn.pressed.connect(_on_quit_pressed)

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
		var card: Control = COURSE_CARD_SCENE.instantiate()
		var display_name: String = course_id
		if category_names.has(course_id):
			display_name = category_names[course_id]
		
		if card.has_method("setup"):
			card.call("setup", course_id, display_name)

		if card.has_signal("course_selected"):
			card.connect("course_selected", _on_category_selected)

		buttons_container.add_child(card)

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

func _on_settings_pressed() -> void:
	if sfx_click: sfx_click.play()
	if settings_overlay and settings_overlay.has_method("open_menu"):
		settings_overlay.open_menu()

func _on_credits_pressed() -> void:
	if sfx_click: sfx_click.play()
	if credits_overlay and credits_overlay.has_method("open_menu"):
		credits_overlay.open_menu()

func _on_settings_closed() -> void:
	if settings_btn:
		settings_btn.grab_focus()

func _on_credits_closed() -> void:
	if credits_btn:
		credits_btn.grab_focus()

func _on_quit_pressed() -> void:
	if sfx_click: sfx_click.play()
	# Ensure this doesn't accidentally trigger if we are in a popup or something
	if difficulty_popup and difficulty_popup.visible:
		difficulty_popup.hide()
		return

	get_tree().quit()
