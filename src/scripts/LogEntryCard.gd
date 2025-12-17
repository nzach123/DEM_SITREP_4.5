extends PanelContainer

@onready var status_label: Label = $MarginContainer/HBoxContainer/StatusLabel
@onready var question_label: Label = $MarginContainer/HBoxContainer/ContentVBox/QuestionLabel
@onready var feedback_label: Label = $MarginContainer/HBoxContainer/ContentVBox/FeedbackLabel

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
