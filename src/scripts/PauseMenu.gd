extends Control
class_name PauseMenu

signal resume_requested
signal restart_requested
signal main_menu_requested
signal quit_requested

@onready var menu_root: Control = $Panel/VBoxContainer
@onready var click_sfx: AudioStreamPlayer = $ClickSFX
@onready var color_rect: ColorRect = $ColorRect

# Preload the SettingsOverlay
const SETTINGS_SCENE: PackedScene = preload("res://src/scenes/SettingsOverlay.tscn")

var settings_instance: Control = null
var is_closing: bool = false

func _ready() -> void:
	hide()

func _on_continue_pressed() -> void:
	if click_sfx: click_sfx.play()
	resume_requested.emit()

func _on_restart_pressed() -> void:
	if click_sfx: click_sfx.play()
	restart_requested.emit()

func _on_main_menu_pressed() -> void:
	if click_sfx: click_sfx.play()
	main_menu_requested.emit()

func _on_quit_pressed() -> void:
	if click_sfx: click_sfx.play()
	quit_requested.emit()

func _on_settings_pressed() -> void:
	if click_sfx: click_sfx.play()

	if settings_instance == null:
		settings_instance = SETTINGS_SCENE.instantiate()
		add_child(settings_instance)
		if settings_instance.has_signal("close_requested"):
			settings_instance.close_requested.connect(_on_settings_closed)

	menu_root.hide()
	if settings_instance.has_method("open_menu"):
		settings_instance.open_menu()
	else:
		settings_instance.show()

func _on_settings_closed() -> void:
	menu_root.show()
	if settings_instance:
		settings_instance.hide()

func open_menu() -> void:
	show()
	is_closing = false
	if color_rect:
		color_rect.color.a = 0.0
		var tween: Tween = create_tween()
		tween.tween_property(color_rect, "color:a", 0.7, 0.2)
	
	# Focus the first button for keyboard/gamepad navigation
	if menu_root:
		var first_btn = menu_root.get_node_or_null("Continue")
		if first_btn and first_btn is Control:
			first_btn.grab_focus()

func close_menu() -> void:
	if is_closing: return
	is_closing = true

	if color_rect:
		var tween: Tween = create_tween()
		tween.tween_property(color_rect, "color:a", 0.0, 0.2)
		tween.tween_callback(queue_free)
	else:
		queue_free()
