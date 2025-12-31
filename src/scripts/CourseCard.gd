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
		title_label.text = display_name

func _on_pressed() -> void:
	course_selected.emit(course_id)
