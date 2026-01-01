extends Control
class_name GameSession

enum State { SETUP, PLAYING, LOCKED, END }

# --- COMPONENTS (Inspector-First) ---
@export_group("Components")
@export var audio_manager: QuizAudioManager
@export var game_camera: QuizCamera
@export var background_pulse: BackgroundPulse
@export var strike_system: QuizStrikeSystem

# --- UI NODES ---
@export_group("UI Elements")
@export var question_label: Label
@export var round_time_label: Label
@export var rescued_value_label: Label
@export var casualties_value_label: Label
@export var timer_label: Label
@export var timer_bar: ProgressBar
@export var rescue_bar: ProgressBar
@export var feedback_label: Label
@export var remediation_popup: Control # RemediationPopup
@export var answer_buttons: Array[Button]
@onready var crt_screen: ColorRect = $CRTScreen

# --- TIMERS ---
@export_group("Timers")
@export var question_timer: Timer
@export var round_timer: Timer

const MATCHING_POPUP_SCENE: PackedScene = preload("res://src/scenes/MatchingEventPopup.tscn")

# --- STATE VARIABLES ---
var current_state: State = State.SETUP
var current_q_index: int = 0
var current_shuffled_answers: Array[Dictionary] = []
var save_weight: int = 0
var strike_streak: int = 0
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

const MAX_STRIKES: int = 3
const FIELD_EXERCISE_CHANCE: float = 0.15

func _ready() -> void:
	_connect_signals()

	# Initial Setup
	if strike_system: strike_system.reset_visuals()
	if background_pulse: background_pulse.update_pulse(0)
	if audio_manager: audio_manager.stop_ambience()

	# Load Data and Start
	if GameManager.questions_pool.size() > 0:
		start_game()
	elif OS.is_debug_build() and GameManager.load_course_data("1110"):
		print("Debug Build: Auto-loaded course 1110")
		start_game()
	else:
		print("No questions loaded in pool. Returning to menu.")
		feedback_label.text = "ERROR: NO DATA"
		feedback_label.visible = true
		await get_tree().create_timer(2.0).timeout
		GameManager.quit_to_main()

func _process(_delta: float) -> void:
	if not question_timer.is_stopped() and not question_timer.paused:
		timer_label.text = "Time: " + str(int(question_timer.time_left))
		timer_bar.value = question_timer.time_left
		if question_timer.time_left < 5:
			timer_bar.modulate = Color(1, 0, 0)
		else:
			timer_bar.modulate = Color(1, 1, 1)

	if not round_timer.is_stopped() and not round_timer.paused:
		if round_time_label:
			round_time_label.text = str(int(round_timer.time_left))

func start_game() -> void:
	GameManager.reset_stats()
	GameManager.reset_session_pool()
	var settings: Dictionary = GameManager.get_current_settings()

	current_q_index = 0
	GameManager.questions_pool.shuffle()

	strike_streak = 0
	if strike_system: strike_system.reset_visuals()

	# Apply Difficulty Slicing
	var target_count: int = int(settings["question_count"])
	var actual_count: int = min(GameManager.questions_pool.size(), target_count)
	GameManager.questions_pool = GameManager.questions_pool.slice(0, actual_count)

	# Calculate Population (Fixed for Session)
	var pop_range: Dictionary = settings["population_range"]
	GameManager.total_population = rng.randi_range(pop_range["min"], pop_range["max"])

	if actual_count > 0:
		save_weight = int(ceil(float(GameManager.total_population) / float(actual_count)))
	else:
		save_weight = 100

	# Setup Timers
	var total_time: float = actual_count * float(settings["time_per_question"])
	round_timer.start(total_time)

	question_timer.wait_time = float(settings["time_per_question"])
	timer_bar.max_value = question_timer.wait_time

	# Setup UI
	update_rescue_ui()
	update_score_ui()

	if audio_manager and audio_manager.sfx_ambience:
		audio_manager.sfx_ambience.play()

	current_state = State.PLAYING
	load_question(0)
	

func load_question(index: int, skip_event_check: bool = false) -> void:
	if index >= GameManager.questions_pool.size():
		finish_game()
		return

	# Field Exercise Check
	if not skip_event_check and current_q_index > 0 and rng.randf() < FIELD_EXERCISE_CHANCE:
		_trigger_field_exercise()
		return

	var q_data: Dictionary = GameManager.questions_pool[index]

	# Validate answers array
	if not q_data.has("answers") or not (q_data["answers"] is Array) or q_data["answers"].is_empty():
		print("Error: Invalid question data at index ", index)
		current_shuffled_answers.clear()
		for btn in answer_buttons:
			btn.hide()
		current_state = State.LOCKED
		feedback_label.text = "SYSTEM ERROR: INVALID DATA"
		feedback_label.visible = true
		return

	_reset_button_visuals()
	current_state = State.PLAYING
	feedback_label.text = ""
	feedback_label.visible = false
	timer_bar.modulate = Color(1, 1, 1)

	# --- Triage Sequence ---
	if audio_manager:
		audio_manager.play_incoming_alert()

	await get_tree().create_timer(0.5).timeout

	_animate_text(question_label, q_data.get("question", "Error: No Question Text"))
	if audio_manager: audio_manager.play_typewriter()
	
	# Explicit casting/copying for strict typing
	current_shuffled_answers.clear()
	for ans in q_data["answers"]:
		if ans is Dictionary:
			current_shuffled_answers.append(ans)

	current_shuffled_answers.shuffle()

	for i in range(answer_buttons.size()):
		if i < current_shuffled_answers.size():
			answer_buttons[i].text = current_shuffled_answers[i].get("text", "")
			answer_buttons[i].show()
		else:
			answer_buttons[i].hide()

	question_timer.start()

func _trigger_field_exercise() -> void:
	current_state = State.LOCKED
	question_timer.paused = true
	round_timer.paused = true

	var popup = MATCHING_POPUP_SCENE.instantiate()
	if crt_screen:
		crt_screen.add_child(popup)
	else:
		add_child(popup)
		
	if popup.has_signal("completed"):
		popup.completed.connect(_on_field_exercise_completed.bind(popup))

	if popup.has_method("setup"):
		popup.setup()

func _on_field_exercise_completed(success: bool, popup: Node) -> void:
	popup.queue_free()

	feedback_label.visible = true
	if success:
		GameManager.rescue_multiplier *= 1.25 # Multiplicative Stacking
		feedback_label.text = "FIELD EXERCISE COMPLETE: EFFICIENCY BOOSTED"
		feedback_label.modulate = Color.CYAN
		if audio_manager: audio_manager.play_correct()
	else:
		feedback_label.text = "FIELD EXERCISE FAILED"
		feedback_label.modulate = Color.ORANGE

	await get_tree().create_timer(2.0).timeout
	feedback_label.visible = false

	question_timer.paused = false
	round_timer.paused = false

	load_question(current_q_index, true)

func _on_button_pressed(selected_idx: int) -> void:
	if current_state != State.PLAYING: return

	if audio_manager: audio_manager.play_click()
	current_state = State.LOCKED
	question_timer.stop()

	var q_data: Dictionary = GameManager.questions_pool[current_q_index]
	var selected_answer_obj: Dictionary = current_shuffled_answers[selected_idx]
	var is_correct: bool = selected_answer_obj.get("is_correct", false)

	if is_correct:
		_handle_correct(selected_idx)
		# Wait and load next
		await get_tree().create_timer(1.5).timeout
		if current_state != State.END:
			current_q_index += 1
			load_question(current_q_index)
	else:
		# Find correct index for highlighting
		var correct_idx: int = -1
		for i in range(current_shuffled_answers.size()):
			if current_shuffled_answers[i].get("is_correct", false):
				correct_idx = i
				break
		_handle_wrong(selected_idx, correct_idx, q_data, selected_answer_obj.get("text", ""))

func _handle_correct(idx: int) -> void:
	if audio_manager: audio_manager.play_correct()

	strike_streak = 0
	if strike_system: strike_system.reset_visuals()
	if background_pulse: background_pulse.update_pulse(0)

	var q_data: Dictionary = GameManager.questions_pool[current_q_index]
	var user_choice_text: String = answer_buttons[idx].text
	GameManager.log_attempt(q_data["question"], user_choice_text, user_choice_text, true)

	var actual_saved = int(save_weight * GameManager.rescue_multiplier)
	GameManager.citizens_saved += actual_saved
	# Cap removed because we check for >= total_population

	feedback_label.text = "INTEL VERIFIED (+%d)" % actual_saved
	feedback_label.modulate = Color.CYAN
	feedback_label.visible = true

	if game_camera: game_camera.apply_shake_bonus(actual_saved)

	GameManager.add_correct_answer()
	update_score_ui()
	update_rescue_ui()

	if idx >= 0 and idx < answer_buttons.size():
		answer_buttons[idx].modulate = Color.GREEN

	if GameManager.citizens_saved >= GameManager.total_population:
		_trigger_victory()
		return

func _handle_wrong(selected_idx: int, correct_idx: int, q_data: Dictionary, user_choice_text: String) -> void:
	if audio_manager: audio_manager.play_wrong()

	strike_streak += 1
	if strike_system: strike_system.update_visuals(strike_streak)
	if background_pulse: background_pulse.update_pulse(strike_streak)

	var penalty: int = int(GameManager.get_current_settings()["casualty_penalty"])
	GameManager.casualties_count += penalty

	feedback_label.text = "SIGNAL LOST: %d CASUALTIES" % penalty
	feedback_label.modulate = Color.ORANGE
	feedback_label.visible = true

	if game_camera: game_camera.apply_casualty_shake()

	# Do NOT reduce total_population anymore.

	update_score_ui()

	var correct_text: String = "Unknown"
	for ans in current_shuffled_answers:
		if ans.get("is_correct", false):
			correct_text = ans.get("text", "Unknown")
			break

	GameManager.log_attempt(q_data["question"], user_choice_text, correct_text, false)

	# Visuals
	if selected_idx != -1 and selected_idx < answer_buttons.size():
		answer_buttons[selected_idx].modulate = Color.RED
	if correct_idx != -1 and correct_idx < answer_buttons.size():
		answer_buttons[correct_idx].modulate = Color.GREEN

	if strike_streak >= MAX_STRIKES:
		_trigger_game_over()
		return

	# Remediation
	round_timer.paused = true
	question_timer.paused = true

	await get_tree().create_timer(1.5).timeout

	var explanation: String = q_data.get("explanation", "No explanation provided.")
	if remediation_popup:
		remediation_popup.call("set_explanation", explanation)
		remediation_popup.show()

func _trigger_game_over() -> void:
	current_state = State.END
	feedback_label.text = "CRITICAL FAILURE: 3 STRIKES"
	feedback_label.visible = true

	if strike_system: strike_system.trigger_game_over_sequence()
	if audio_manager: audio_manager.play_alarm()

	await get_tree().create_timer(2.0).timeout
	finish_game()

func _trigger_victory() -> void:
	current_state = State.END
	question_timer.stop()
	round_timer.stop()

	feedback_label.text = "MISSION ACCOMPLISHED"
	feedback_label.modulate = Color.GREEN
	feedback_label.visible = true

	if audio_manager: audio_manager.play_correct()

	await get_tree().create_timer(2.0).timeout
	finish_game()

func finish_game() -> void:
	current_state = State.END
	question_timer.stop()
	round_timer.stop()
	if audio_manager: audio_manager.stop_ambience()

	# Save Logic
	var total_attempted: int = GameManager.correct_answers_count + GameManager.session_log.size()
	var mastery_percent: float = 0.0
	if total_attempted > 0:
		mastery_percent = (float(GameManager.correct_answers_count) / total_attempted) * 100.0

	var course_id: String = GameManager.current_course_id
	if not GameManager.player_progress.has(course_id):
		GameManager.player_progress[course_id] = { "high_score": 0, "mastery_percent": 0.0, "max_citizens_saved": 0 }

	var progress = GameManager.player_progress[course_id]
	if not progress.has("max_citizens_saved"): progress["max_citizens_saved"] = 0
	if not progress.has("mastery_percent"): progress["mastery_percent"] = 0.0

	if GameManager.citizens_saved > progress["max_citizens_saved"]:
		progress["max_citizens_saved"] = GameManager.citizens_saved

	if mastery_percent > progress["mastery_percent"]:
		progress["mastery_percent"] = mastery_percent

	GameManager.save_game()

	# Outcome Feedback
	var rescue_percentage: float = 0.0
	if GameManager.total_population > 0:
		rescue_percentage = float(GameManager.citizens_saved) / float(GameManager.total_population)

	question_label.text = "OPERATION COMPLETE"

	if strike_streak >= MAX_STRIKES:
		feedback_label.text = "MISSION FAILED: SYSTEM LOCKOUT"
		feedback_label.modulate = Color.RED
	elif GameManager.citizens_saved >= GameManager.total_population:
		feedback_label.text = "SUCCESS: ALL CITIZENS SAVED"
		feedback_label.modulate = Color.GREEN
	elif rescue_percentage >= 0.5:
		feedback_label.text = "SUCCESS: CIVILIAN EVAC COMPLETE"
		feedback_label.modulate = Color.GREEN
	else:
		feedback_label.text = "MISSION FAILED: CASUALTIES TOO HIGH"
		feedback_label.modulate = Color.RED

	feedback_label.visible = true

	await get_tree().create_timer(2.0).timeout
	GameManager.change_scene("res://src/scenes/AARScreen.tscn")

# --- HELPERS ---

func _animate_text(label: Label, text_content: String) -> void:
	label.text = text_content
	label.visible_ratio = 0.0
	var tween: Tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, text_content.length() * 0.02)

func _connect_signals() -> void:
	question_timer.timeout.connect(_on_question_timeout)
	round_timer.timeout.connect(_on_round_timeout)

	if remediation_popup and remediation_popup.has_signal("acknowledged"):
		if not remediation_popup.acknowledged.is_connected(_on_remediation_acknowledged):
			remediation_popup.acknowledged.connect(_on_remediation_acknowledged)

	for i in range(answer_buttons.size()):
		if answer_buttons[i].pressed.is_connected(_on_button_pressed):
			answer_buttons[i].pressed.disconnect(_on_button_pressed)
		answer_buttons[i].pressed.connect(_on_button_pressed.bind(i))

func _on_question_timeout() -> void:
	if current_state != State.PLAYING: return
	current_state = State.LOCKED

	if audio_manager: audio_manager.play_alarm()

	var q_data: Dictionary = GameManager.questions_pool[current_q_index]
	var correct_idx: int = 0
	for i in range(current_shuffled_answers.size()):
		if current_shuffled_answers[i].get("is_correct", false):
			correct_idx = i
			break

	_handle_wrong(-1, correct_idx, q_data, "TIMEOUT")

func _on_round_timeout() -> void:
	finish_game()

func _on_remediation_acknowledged() -> void:
	if remediation_popup: remediation_popup.hide()

	round_timer.paused = false
	question_timer.paused = false

	current_q_index += 1
	load_question(current_q_index)

func update_score_ui() -> void:
	if rescued_value_label:
		rescued_value_label.text = str(GameManager.citizens_saved)
	if casualties_value_label:
		casualties_value_label.text = str(GameManager.casualties_count)

func update_rescue_ui() -> void:
	rescue_bar.min_value = 0
	rescue_bar.max_value = GameManager.total_population

	var tween: Tween = create_tween()
	tween.tween_property(rescue_bar, "value", GameManager.citizens_saved, 0.4).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	rescue_bar.tooltip_text = "Civilian Status: Evacuation in Progress"

func _reset_button_visuals() -> void:
	for btn in answer_buttons:
		btn.modulate = Color.WHITE
		btn.show()
