extends Control
class_name AARScreen

# Signals
signal report_finished

# Exported Nodes (assigned via Unique Names in Scene or manual hookups)
@export_group("Report UI")
@onready var report_body: RichTextLabel = %ReportBody
@onready var action_buttons: Control = %ActionButtons
@onready var retry_button: Button = %RetryButton
@onready var menu_button: Button = %MenuButton

@export_group("Log UI")
@export var mistake_container: VBoxContainer
@export var no_data_label: Label

const MONTSERRAT_BUTTON_THEME = preload("res://content/resources/themes/Montserrat_button_theme.tres")
@export_group("Audio")
@export var audio_manager: Node
@export var victory_music: AudioStream
@export var fail_music: AudioStream
@onready var sfx_tick: AudioStreamPlayer = $SfxTick
@onready var sfx_stamp: AudioStreamPlayer = $SfxStamp

# Constants
const TYPE_SPEED: float = 0.03 # Seconds per character
const AUDIO_FREQUENCY: int = 3 # Play sound every Nth character
const LOG_CARD_SCENE: PackedScene = preload("res://src/scenes/LogEntryCard.tscn")

# State
var _is_printing: bool = false
var _full_text: String = ""

func _ready() -> void:
	# Fallback if audio_manager isn't set
	if not audio_manager:
		audio_manager = get_node_or_null("AudioManager")
		if not audio_manager:
			push_warning("AARScreen: AudioManager not found!")

	if mistake_container:
		mistake_container.add_theme_constant_override("separation", 8)

	# Connect Buttons
	if retry_button:
		retry_button.pressed.connect(_on_retry_pressed)
	if menu_button:
		menu_button.pressed.connect(_on_menu_pressed)

	# Setup Data
	var score_pct: float = 0.0
	if GameManager.session.total_population > 0:
		score_pct = float(GameManager.session.citizens_saved) / float(GameManager.session.total_population)

	# Generate Date String
	var date_dict = Time.get_datetime_dict_from_system()
	var date_str = "%04d-%02d-%02d %02d:%02d" % [date_dict.year, date_dict.month, date_dict.day, date_dict.hour, date_dict.minute]

	setup_aar(score_pct * 100.0, date_str) # Pass as percentage 0-100

func setup_aar(score_percent: float, date_str: String):
	# 1. Generate the Report Text
	var grade_status = _get_grade_status(score_percent)
	var citizens_saved = GameManager.session.citizens_saved
	var casualties = GameManager.session.casualties_count
	var course_id = GameManager.current_course_id

	_full_text = """[b]OFFICIAL INCIDENT INQUIRY[/b]
--------------------------------
DATE: %s
MISSION ID: %s
OPERATIVE: [REDACTED]

METRICS ANALYSIS:
> CITIZENS SECURED: %d
> CASUALTIES: %d
> EFFICIENCY RATING: %.1f%%

FINAL ASSESSMENT:
%s
--------------------------------
""" % [date_str, course_id.to_upper(), citizens_saved, casualties, score_percent, grade_status]

	# 2. Reset State
	if report_body:
		report_body.text = _full_text
		report_body.visible_ratio = 0.0

	if action_buttons:
		action_buttons.visible = true
		action_buttons.modulate.a = 0.0 # Prepare for fade in if we want, or just set visible

	_is_printing = true

	# 3. Populate Log (Passive)
	_populate_log()

	# 4. Start Typewriter
	_start_typewriter()

func _get_grade_status(score: float) -> String:
	if score >= 90:
		return "[color=green]EXEMPLARY PERFORMANCE\nSTATUS: COMMENDATION RECOMMENDED[/color]"
	elif score >= 70:
		return "[color=yellow]ACCEPTABLE\nSTATUS: STANDARD PROTOCOL OBSERVED[/color]"
	else:
		return "[color=red]CRITICAL FAILURE\nSTATUS: REMEDIAL TRAINING ASSIGNED[/color]"

func _start_typewriter():
	if not report_body:
		_finish_printing()
		return

	var total_chars = report_body.get_total_character_count()
	var current_char = 0

	# Ensure audio matches text
	while current_char < total_chars and _is_printing:
		current_char += 1
		report_body.visible_characters = current_char

		# Audio Logic
		if current_char % AUDIO_FREQUENCY == 0:
			if sfx_tick:
				sfx_tick.pitch_scale = randf_range(0.95, 1.05)
				sfx_tick.play()

		await get_tree().create_timer(TYPE_SPEED).timeout

	_finish_printing()

func _finish_printing():
	if not _is_printing: return # Already finished

	_is_printing = false
	if report_body:
		report_body.visible_ratio = 1.0

	if action_buttons:
		action_buttons.visible = true
		var tween = create_tween()
		tween.tween_property(action_buttons, "modulate:a", 1.0, 0.5)

	# Play the "Stamp" sound for finality
	if sfx_stamp:
		sfx_stamp.play()

	emit_signal("report_finished")

	# Play Result Music based on score
	var percent = 0.0
	if GameManager.session.total_population > 0:
		percent = float(GameManager.session.citizens_saved) / float(GameManager.session.total_population)

	if percent < 0.7: # Using 70% threshold for music too? Or stick to simple pass/fail?
		# Original code used 0.5. Let's align with "Critical Failure" being < 70
		if audio_manager and fail_music: audio_manager.play_music(fail_music)
	else:
		if audio_manager and victory_music: audio_manager.play_music(victory_music)

func _input(event):
	# Allow user to skip the typing animation
	if _is_printing and (event is InputEventMouseButton and event.pressed) or (event.is_action_pressed("ui_accept")):
		_finish_printing()
		get_viewport().set_input_as_handled()

func _populate_log() -> void:
	if not mistake_container: return

	# Clear previous
	for child in mistake_container.get_children():
		if child != no_data_label:
			child.queue_free()

	var has_data = (GameManager.session.session_log.size() > 0)
	if not has_data:
		if no_data_label: no_data_label.show()
	else:
		if no_data_label: no_data_label.hide()
		# Create cards
		for entry in GameManager.session.session_log:
			var card: Control = LOG_CARD_SCENE.instantiate()
			mistake_container.add_child(card)
			if card.has_method("setup"):
				card.call("setup", entry)

func _on_retry_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	GameManager.change_scene("res://src/scenes/quiz_scene.tscn")

func _on_menu_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	GameManager.change_scene("res://src/scenes/MainMenu.tscn")
