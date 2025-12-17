extends Button

signal course_selected(course_id: String)

var course_id: String = ""

func _ready() -> void:
	pressed.connect(_on_pressed)

func setup(id: String, display_name: String) -> void:
	course_id = id
	text = display_name

func _on_pressed() -> void:
	course_selected.emit(course_id)
