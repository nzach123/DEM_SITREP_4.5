extends Control
class_name SplashScreen

const LOAD_SCENE = preload("res://src/scenes/MainMenu.tscn")
@export var in_time: float = 0.5
@export var fade_in_time: float = 1.5
@export var pause_time: float = 1.5
@export var fade_out_time: float = 0.5
@export var out_time: float = 0.5
@export var splash_screen: TextureRect
@export var click_to_start_label: Control

var _is_changing_scene: bool = false
var is_web_mode_override: bool = false # For testing
var is_waiting_for_web_input: bool = false

func _ready() -> void:
	if not splash_screen:
		push_error("Splash screen TextureRect not assigned!")
		return
	
	if click_to_start_label:
		click_to_start_label.hide()
	
	fade()

func fade() -> void:
	splash_screen.modulate.a = 0.0
	var tween = self.create_tween()
	tween.tween_interval(in_time)
	tween.tween_property(splash_screen, "modulate:a", 1.0, fade_in_time)
	tween.tween_interval(pause_time)
	
	# If on web and no input yet, we stay at full opacity and wait
	if OS.has_feature("web") or is_web_mode_override:
		await tween.finished
		if not _is_changing_scene:
			_prompt_web_click()
		return

	tween.tween_property(splash_screen, "modulate:a", 0.0, fade_out_time)
	tween.tween_interval(out_time)
	await tween.finished

	if not _is_changing_scene:
		_change_scene()

func _prompt_web_click() -> void:
	is_waiting_for_web_input = true
	if click_to_start_label:
		click_to_start_label.show()
		# Simple blink animation for the label
		var tween = create_tween().set_loops()
		tween.tween_property(click_to_start_label, "modulate:a", 0.3, 0.8)
		tween.tween_property(click_to_start_label, "modulate:a", 1.0, 0.8)

func _input(event: InputEvent) -> void:
	if _is_changing_scene:
		return

	# We only want to interrupt if we are waiting for web input
	# OR if we are just skipping the animation (optional, but good for UX)
	# But for the specific Web requirement:
	if OS.has_feature("web") or is_web_mode_override:
		if not is_waiting_for_web_input:
			return # Don't allow skipping the fade-in, only the wait state? 
			# Actually, standard behavior is usually "click to skip splash".
			# But if we strictly want to enforce the "wait for click" state:
			pass 
		
	if event.is_pressed():
		# If we are waiting for web input, any press triggers it.
		# If we are simply animating, a press could skip it (if desired).
		# For now, let's just make sure it triggers the change.
		
		# Prevent double-firing
		set_process_input(false)
		_change_scene()

func _change_scene() -> void:
	if _is_changing_scene:
		return

	_is_changing_scene = true
	set_process_unhandled_input(false)

	if LOAD_SCENE:
		get_tree().change_scene_to_packed(LOAD_SCENE)
	else:
		push_error("MainMenu scene failed to load!")
