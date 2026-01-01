extends Control
class_name ShiftSummary

@export var title_label: Label
@export var clock_out_btn: Button
@export var overtime_btn: Button

func _ready() -> void:
	if clock_out_btn:
		clock_out_btn.pressed.connect(_on_clock_out_pressed)
	if overtime_btn:
		overtime_btn.pressed.connect(_on_overtime_pressed)

	# Initial focus
	if overtime_btn:
		overtime_btn.grab_focus()

func _on_clock_out_pressed() -> void:
	# Return to Main Menu
	GameManager.change_scene("res://src/scenes/MainMenu.tscn")

func _on_overtime_pressed() -> void:
	# Reload current scene to continue (GameSession will pick up from saved index)
	# Since we saved progress at Shift End, reloading essentially "Resumes"
	# BUT: We need to make sure we don't double-increment or anything.
	# GameSession.start_game() loads from ProfileManager.
	# So reloading the scene is the cleanest way to reset state/timers for the new shift.
	get_tree().reload_current_scene()
