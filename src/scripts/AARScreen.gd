extends Control
class_name AARScreen

@export_group("Audio")
@export var sfx_click: AudioStreamPlayer
@export var sfx_result: AudioStreamPlayer
@export var sfx_pop: AudioStream = preload("res://assets/audio/sfx/ClickSFX/maximize_004.ogg")

@export_group("UI Nodes")
@export var rank_letter: Label
@export var score_value: Label
@export var mastery_value: Label
@export var retry_button: Button
@export var menu_button: Button
@export var mistake_container: VBoxContainer
@export var no_data_label: Label

const MONTSERRAT_BUTTON_THEME = preload("res://content/resources/themes/Montserrat_button_theme.tres")
var sfx_success: AudioStream = preload("res://assets/audio/music/Loops/Retro Polka.ogg")
var sfx_fail: AudioStream = preload("res://assets/audio/music/Loops/computerNoise_003.ogg")
const LOG_CARD_SCENE: PackedScene = preload("res://src/scenes/LogEntryCard.tscn")

var button_wrappers: Dictionary = {}

func _ready() -> void:
	if mistake_container:
		mistake_container.add_theme_constant_override("separation", 8)

	# Wrap buttons for animation
	if retry_button: _wrap_button(retry_button)
	if menu_button: _wrap_button(menu_button)

	display_results()
	if retry_button: retry_button.pressed.connect(_on_retry_pressed)
	if menu_button: menu_button.pressed.connect(_on_menu_pressed)

func _wrap_button(btn: Control) -> void:
	# 1. Create wrapper
	var wrapper = Control.new()
	wrapper.name = btn.name + "_Wrapper"
	wrapper.mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE # Let click pass through? No, wrapper just holds.

	# Inherit size flags
	wrapper.size_flags_horizontal = btn.size_flags_horizontal
	wrapper.size_flags_vertical = btn.size_flags_vertical

	# 2. Inject into tree
	var parent = btn.get_parent()
	var idx = btn.get_index()
	parent.remove_child(btn)
	parent.add_child(wrapper)
	parent.move_child(wrapper, idx)

	# 3. Add btn to wrapper
	wrapper.add_child(btn)

	# 4. Sizing logic (Bidirectional)
	# Wrapper needs min size of button
	btn.resized.connect(func():
		wrapper.custom_minimum_size = btn.size
	)
	# Force initial
	wrapper.custom_minimum_size = btn.size

	# Hide button initially (alpha only, so it still takes space/calculates size)
	btn.modulate.a = 0.0

	button_wrappers[btn] = wrapper

func _on_retry_pressed() -> void:
	await play_click()
	_on_retry()

func _on_menu_pressed() -> void:
	await play_click()
	_on_menu()

func display_results() -> void:
	if score_value: score_value.text = str(GameManager.citizens_saved)

	# Display Mastery
	var course_id: String = GameManager.current_course_id
	var mastery_text: String = "MASTERY: 0%"

	if GameManager.player_progress.has(course_id):
		var p_data: Dictionary = GameManager.player_progress[course_id]
		var mastery: float = p_data.get("mastery_percent", 0.0)
		mastery_text = "MASTERY: %.1f%%" % mastery

	if mastery_value:
		mastery_value.text = mastery_text
		mastery_value.modulate = Color(1.0, 1.0, 1.0)

	# Calculate Rank
	var saved: int = GameManager.citizens_saved
	var total: int = GameManager.total_population
	var percent: float = 0.0
	if total > 0: percent = float(saved) / float(total)

	var rank_char: String = "F"
	var color: Color = Color(0.9, 0, 0) # Red

	if percent >= 1.0:
		rank_char = "S"
		color = Color(1, 0.84, 0) # Gold
	elif percent >= 0.8:
		rank_char = "A"
		color = Color(0, 1, 0) # Green
	elif percent >= 0.5:
		rank_char = "B"
		color = Color(0.5, 0.5, 1) # Blue

	if rank_letter:
		rank_letter.text = rank_char
		rank_letter.modulate = color

		# Animate Rank
		var tween: Tween = create_tween().set_loops()
		tween.tween_property(rank_letter, "modulate:a", 0.5, 0.8)
		tween.tween_property(rank_letter, "modulate:a", 1.0, 0.8)

	# Play Audio
	if sfx_result:
		if percent < 0.5:
			sfx_result.stream = sfx_fail
		else:
			sfx_result.stream = sfx_success
		sfx_result.play()

	# History Display
	var mistakes_duration: float = 0.0
	if mistake_container:
		# Clear any dummy children first, preserving NoDataLabel
		for child in mistake_container.get_children():
			if child != no_data_label:
				child.queue_free()

		var has_data = (GameManager.session_log.size() > 0)
		if not has_data:
			if no_data_label: no_data_label.show()
			mistakes_duration = 0.5 # Small pause
		else:
			if no_data_label: no_data_label.hide()
			# Create cards first
			var cards: Array[Control] = []
			for entry in GameManager.session_log:
				var card: Control = LOG_CARD_SCENE.instantiate()
				mistake_container.add_child(card)
				if card.has_method("setup"):
					card.call("setup", entry)
				cards.append(card)

			# Animate sequence
			_animate_mistakes_sequence(cards)
			mistakes_duration = cards.size() * 0.05

	# Animate Buttons after mistakes
	_animate_buttons(mistakes_duration + 0.5)

func _animate_mistakes_sequence(cards: Array[Control]) -> void:
	for i in range(cards.size()):
		var card = cards[i]
		if card.has_method("animate_entry"):
			# Fast shuffle timing: 0.05s per card
			var delay: float = i * 0.05
			# Random pitch for tactile "deck shuffle" feel
			var pitch: float = randf_range(0.9, 1.1)
			card.call("animate_entry", delay, sfx_pop, pitch)

func _animate_buttons(start_delay: float) -> void:
	var buttons = []
	if retry_button: buttons.append(retry_button)
	if menu_button: buttons.append(menu_button)

	for i in range(buttons.size()):
		var btn = buttons[i]
		# Initial state
		btn.modulate.a = 0.0
		btn.position.y = 50.0 # Slide from bottom

		# Wait for start delay + sequential delay
		var delay = start_delay + (i * 0.15)

		var tween = create_tween()
		tween.tween_interval(delay)

		tween.tween_callback(func():
			# Play Sound
			var asp = AudioStreamPlayer.new()
			asp.stream = sfx_pop
			asp.pitch_scale = randf_range(0.95, 1.05)
			asp.bus = "SFX"
			add_child(asp)
			asp.play()
			asp.finished.connect(asp.queue_free)
		)

		tween.set_parallel(true)
		tween.tween_property(btn, "modulate:a", 1.0, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(btn, "position:y", 0.0, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func _on_retry() -> void:
	GameManager.change_scene("res://src/scenes/quiz_scene.tscn")

func _on_menu() -> void:
	GameManager.change_scene("res://src/scenes/MainMenu.tscn")

func play_click() -> void:
	if sfx_click:
		sfx_click.play()
		await sfx_click.finished
