extends CanvasLayer
class_name PauseMenu

signal resume_requested
signal restart_requested
signal quit_requested

@onready var menu_root = $CenterContainer/MenuRoot
@onready var click_sfx = $ClickSFX
@onready var color_rect = $ColorRect

# Preload the SettingsOverlay
const SETTINGS_SCENE = preload("res://src/scenes/SettingsOverlay.tscn")

var settings_instance = null

func _ready():
	hide()

# Removed _input logic as it is likely handled by GameManager or redundant.
# If previously present, it might cause conflicts.
# However, if GameManager calls show(), we are good.

func _on_resume_pressed():
	if click_sfx: click_sfx.play()
	_animate_hide(resume_requested)

func _on_restart_pressed():
	if click_sfx: click_sfx.play()
	_animate_hide(restart_requested)

func _on_quit_pressed():
	if click_sfx: click_sfx.play()
	_animate_hide(quit_requested)

func _on_options_pressed():
	if click_sfx: click_sfx.play()

	if settings_instance == null:
		settings_instance = SETTINGS_SCENE.instantiate()
		add_child(settings_instance)
		settings_instance.close_requested.connect(_on_settings_closed)

	menu_root.hide()
	settings_instance.open_menu()

func _on_settings_closed():
	menu_root.show()
	if settings_instance:
		settings_instance.hide()

func _animate_hide(signal_to_emit: Signal) -> void:
	# Re-adding simple tween animation for polish
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", 0.0, 0.2)
	tween.tween_callback(func():
		hide()
		signal_to_emit.emit()
	)

# Called by GameManager or others
func open_menu() -> void:
	show()
	if color_rect:
		color_rect.color.a = 0.0
		var tween = create_tween()
		tween.tween_property(color_rect, "color:a", 0.7, 0.2)

func close_menu() -> void:
	# Standard hide without signal
	_animate_hide_no_signal()

func _animate_hide_no_signal() -> void:
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", 0.0, 0.2)
	tween.tween_callback(hide)
