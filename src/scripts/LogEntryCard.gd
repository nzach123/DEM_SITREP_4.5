extends PanelContainer

@onready var status_label: Label = $MarginContainer/HBoxContainer/StatusLabel
@onready var question_label: Label = $MarginContainer/HBoxContainer/ContentVBox/QuestionLabel
@onready var feedback_label: Label = $MarginContainer/HBoxContainer/ContentVBox/FeedbackLabel
@onready var evidence_image: TextureRect = $MarginContainer/HBoxContainer/ContentVBox/EvidenceImage

# Animation wrapper
var slider: Control

func _ready() -> void:
	# Inject a "Slider" Control to decouple content position from the root PanelContainer's layout constraints
	_setup_animation_wrapper()

func _setup_animation_wrapper() -> void:
	# 1. Create the slider wrapper (Plain Control)
	slider = Control.new()
	slider.name = "Slider"
	slider.mouse_filter = mouse_filter
	# Crucial: Ensure slider fills the PanelContainer
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.size_flags_vertical = Control.SIZE_EXPAND_FILL

	# 2. Get the content node
	var content = $MarginContainer
	if not content: return

	# 3. Reparent
	if content.get_parent() == self:
		remove_child(content)
		slider.add_child(content)
		add_child(slider)

		# 4. Setup Bidirectional Sizing Logic

		# Downstream: Slider Width -> Content Width
		slider.resized.connect(func():
			_sync_layout(slider.size.x)
		)

		# Upstream: Content Height -> Slider Min Height
		# When content resizes (e.g. text wrap), report new min height to container.
		content.resized.connect(func():
			slider.custom_minimum_size.y = content.size.y
			# Re-enforce width constraints to prevent expansion from text/images
			if slider.size.x > 0:
				var target_width = max(slider.size.x, 200.0)
				if content.size.x != target_width:
					content.size.x = target_width
		)

		# 5. Initial Sync
		_sync_layout(size.x)
		slider.custom_minimum_size.y = content.size.y

func _sync_layout(width: float) -> void:
	var safe_width = max(width, 200.0)
	var content = get_node_or_null("Slider/MarginContainer")
	if not content: return

	content.size.x = safe_width

	# Dynamic Label Sizing to fix min-height calculation bug
	# 15 (Margin) + 80 (Status) + 4 (HBox Sep) + 10 (Safety) = 109 -> 110
	var label_width = safe_width - 110.0
	if label_width < 1.0: label_width = 1.0

	if question_label: question_label.custom_minimum_size.x = label_width
	if feedback_label: feedback_label.custom_minimum_size.x = label_width

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

	# Image Evidence
	if evidence_image:
		var image_path = entry.get("image_path", "")
		if image_path and ResourceLoader.exists(image_path):
			evidence_image.texture = load(image_path)
			evidence_image.show()
		else:
			evidence_image.hide()
			
	# Ensure layout is correct after text changes
	if slider: _sync_layout(slider.size.x)

func animate_entry(delay: float, sfx_stream: AudioStream, pitch_scale: float) -> void:
	# Content is now inside Slider.
	var content = $Slider/MarginContainer
	if not content:
		content = $MarginContainer

	if content:
		# Initial State
		content.modulate.a = 0.0
		# Shift left (-50px) relative to Slider
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
