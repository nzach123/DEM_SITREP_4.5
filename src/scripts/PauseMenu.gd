extends CanvasLayer
class_name PauseMenu

signal resume_requested
signal restart_requested
signal quit_requested

@onready var background: ColorRect = $ColorRect
@onready var menu_root: VBoxContainer = $CenterContainer/MenuRoot
@onready var options_root: VBoxContainer = $CenterContainer/OptionsRoot
@onready var click_sfx: AudioStreamPlayer = $ClickSFX

func _ready() -> void:
	visible = false
	menu_root.modulate.a = 0.0
	background.color.a = 0.0

func open_menu() -> void:
	visible = true
	options_root.visible = false
	menu_root.visible = true

	# Create tween for fade-in effect
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(background, "color:a", 0.5, 0.3)
	tween.tween_property(menu_root, "modulate:a", 1.0, 0.3)

func close_menu() -> void:
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(background, "color:a", 0.0, 0.2)
	tween.tween_property(menu_root, "modulate:a", 0.0, 0.2)
	tween.tween_property(options_root, "modulate:a", 0.0, 0.2)

	await tween.finished
	visible = false

# --- Signal Connections ---

func _on_resume_pressed() -> void:
	click_sfx.play()
	resume_requested.emit()

func _on_restart_pressed() -> void:
	click_sfx.play()
	restart_requested.emit()

func _on_quit_pressed() -> void:
	click_sfx.play()
	quit_requested.emit()

func _on_options_pressed() -> void:
	click_sfx.play()
	menu_root.visible = false
	options_root.visible = true
	options_root.modulate.a = 0.0
	var tween: Tween = create_tween()
	tween.tween_property(options_root, "modulate:a", 1.0, 0.2)

func _on_back_pressed() -> void:
	click_sfx.play()
	options_root.visible = false
	menu_root.visible = true

func _on_volume_slider_value_changed(value: float) -> void:
	var bus_idx: int = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value))
