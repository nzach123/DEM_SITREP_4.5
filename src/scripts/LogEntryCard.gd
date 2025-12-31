extends PanelContainer

@onready var status_label: Label = $MarginContainer/HBoxContainer/StatusLabel
@onready var question_label: Label = $MarginContainer/HBoxContainer/ContentVBox/QuestionLabel
@onready var feedback_label: Label = $MarginContainer/HBoxContainer/ContentVBox/FeedbackLabel

# Animation wrapper
var slider: Control

func _ready() -> void:
	# Inject a "Slider" Control to decouple content position from the root PanelContainer's layout constraints
	_setup_animation_wrapper()

func _setup_animation_wrapper() -> void:
	# Create the slider wrapper
	slider = Control.new()
	slider.name = "Slider"
	# PanelContainer expects children to fill, but we want the child (slider) to respect that
	slider.set_anchors_preset(Control.PRESET_FULL_RECT)
	# Pass mouse filter
	slider.mouse_filter = mouse_filter

	# Get the content node
	var content = $MarginContainer

	# Reparent
	if content and content.get_parent() == self:
		remove_child(content)
		slider.add_child(content)
		add_child(slider)

		# Ensure content fills the slider
		content.set_anchors_preset(Control.PRESET_FULL_RECT)

func setup(entry: Dictionary) -> void:
	var is_success: bool = entry.get("is_correct", false)

	# Status Marker
	if is_success:
		status_label.text = "[ OK ]"
		status_label.modulate = Color.GREEN
	else:
		status_label.text = "[FAIL]"
		status_label.modulate = Color(1.0, 0.2, 0.2)

	# Question Text
	question_label.text = str(entry.get("question", ""))

	# Feedback Text
	var user_choice: String = str(entry.get("user_choice", ""))
	var correct_answer: String = str(entry.get("correct_answer", ""))

	if is_success:
		feedback_label.text = ">> Action Verified: " + user_choice
		feedback_label.modulate = Color(0.5, 1.0, 0.5)
	else:
		feedback_label.text = ">> ERROR: Selected '" + user_choice + "'\n   EXPECTED: '" + correct_answer + "'"
		feedback_label.modulate = Color(1.0, 0.5, 0.5)

func animate_entry(delay: float, sfx_stream: AudioStream, pitch_scale: float) -> void:
	# Content is now inside Slider. If _ready didn't run yet (rare), this might fail.
	# But _ready runs on add_child.
	var content = $Slider/MarginContainer
	if not content:
		# Fallback if setup failed
		content = $MarginContainer

	if content:
		# Initial State
		content.modulate.a = 0.0
		# Shift left (-50px)
		content.position.x = -50.0

		var tween = create_tween()
		tween.tween_interval(delay)

		# Play Sound
		tween.tween_callback(func():
			var asp = AudioStreamPlayer.new()
			asp.stream = sfx_stream
			asp.pitch_scale = pitch_scale
			asp.bus = "SFX"
			add_child(asp)
			asp.play()
			asp.finished.connect(asp.queue_free)
		)

		# Animate Slide & Fade
		tween.set_parallel(true)
		tween.tween_property(content, "modulate:a", 1.0, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(content, "position:x", 0.0, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
