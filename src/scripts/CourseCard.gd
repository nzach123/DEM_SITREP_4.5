class_name CourseCard
extends Button

signal course_selected(course_id: String)

@export var id_label: Label
@export var title_label: Label
@export var progress_label: Label

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

func update_status(current_index: int, total_items: int, shift_size: int) -> void:
	if not progress_label: return

	if current_index == 0:
		progress_label.text = ""
		return

	var current_day: int = floor(current_index / float(shift_size)) + 1
	var total_days: int = ceil(total_items / float(shift_size))

	# Just in case total_items is small or invalid
	if total_days < 1: total_days = 1

	progress_label.text = "DAY %d / %d" % [current_day, total_days]
	progress_label.modulate = Color.GREEN
