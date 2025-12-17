extends Panel

signal difficulty_selected(difficulty: int)

@onready var btn_low: Button = $CenterContainer/VBoxContainer/BtnLow
@onready var btn_med: Button = $CenterContainer/VBoxContainer/BtnMed
@onready var btn_high: Button = $CenterContainer/VBoxContainer/BtnHigh
@onready var btn_cancel: Button = $CenterContainer/VBoxContainer/BtnCancel

func _ready() -> void:
	btn_low.pressed.connect(func(): _emit_diff(GameManager.Difficulty.LOW))
	btn_med.pressed.connect(func(): _emit_diff(GameManager.Difficulty.MEDIUM))
	btn_high.pressed.connect(func(): _emit_diff(GameManager.Difficulty.HIGH))
	btn_cancel.pressed.connect(func(): hide())

func _emit_diff(diff: int) -> void:
	difficulty_selected.emit(diff)
	hide()
