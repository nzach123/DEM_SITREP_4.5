class_name CourseCard
extends Button

signal course_selected(course_id: String)

@export var id_label: Label
@export var title_label: Label

var course_id: String = ""

func _ready() -> void:
	pressed.connect(_on_pressed)

func setup(id: String, display_name: String) -> void:
	course_id = id
	if id_label:
		id_label.text = id
	if title_label:
		# If the display name starts with the ID, strip it for the title label to avoid redundancy,
		# or just keep it as is. The user's wireframe showed:
		# | 1110
		# | RESILIENCE
		# But the current code passes "1110 - Individual..." as display_name.
		# I should parse it or just display it.
		# Current MainMenu.gd logic: display_name = course_id + " - " + str(category_names[course_id])
		# I'll let MainMenu handle the string formatting, or I can split it here.
		# Concept 3 wireframe implies separation.
		title_label.text = display_name

func _on_pressed() -> void:
	course_selected.emit(course_id)
