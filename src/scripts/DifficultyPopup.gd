extends Panel

signal difficulty_selected(difficulty: int)

@onready var quiz_container: VBoxContainer = $CenterContainer/VBoxContainer/QuizContainer
@onready var matching_container: VBoxContainer = $CenterContainer/VBoxContainer/MatchingContainer

@onready var btn_low: Button = $CenterContainer/VBoxContainer/QuizContainer/BtnLow
@onready var btn_med: Button = $CenterContainer/VBoxContainer/QuizContainer/BtnMed
@onready var btn_high: Button = $CenterContainer/VBoxContainer/QuizContainer/BtnHigh

@onready var btn_match_3: Button = $CenterContainer/VBoxContainer/MatchingContainer/BtnMatch3
@onready var btn_match_5: Button = $CenterContainer/VBoxContainer/MatchingContainer/BtnMatch5
@onready var btn_match_10: Button = $CenterContainer/VBoxContainer/MatchingContainer/BtnMatch10

@onready var btn_cancel: Button = $CenterContainer/VBoxContainer/BtnCancel

func _ready() -> void:
	# Quiz Connections
	btn_low.pressed.connect(func(): _emit_diff(GameManager.Difficulty.LOW))
	btn_med.pressed.connect(func(): _emit_diff(GameManager.Difficulty.MEDIUM))
	btn_high.pressed.connect(func(): _emit_diff(GameManager.Difficulty.HIGH))

	# Matching Connections (We reuse the int signal, but interpret it as rounds count)
	btn_match_3.pressed.connect(func(): _emit_diff(3))
	btn_match_5.pressed.connect(func(): _emit_diff(5))
	btn_match_10.pressed.connect(func(): _emit_diff(10))

	btn_cancel.pressed.connect(func(): hide())

func setup(mode: String) -> void:
	if mode == "matching":
		quiz_container.hide()
		matching_container.show()
	else:
		quiz_container.show()
		matching_container.hide()
	show()

func _emit_diff(val: int) -> void:
	difficulty_selected.emit(val)
	hide()
