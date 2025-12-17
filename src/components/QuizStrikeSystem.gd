extends HBoxContainer
class_name QuizStrikeSystem

@export var giant_x_label: Label

@onready var strike_labels: Array[Label] = [
	$Strike1,
	$Strike2,
	$Strike3
]

func _ready() -> void:
	reset_visuals()

func update_visuals(streak: int) -> void:
	for i in range(strike_labels.size()):
		if i < streak:
			strike_labels[i].show()
		else:
			strike_labels[i].hide()

func reset_visuals() -> void:
	for label in strike_labels:
		label.hide()
	if giant_x_label:
		giant_x_label.hide()

func trigger_game_over_sequence() -> void:
	if giant_x_label:
		giant_x_label.show()
		giant_x_label.scale = Vector2.ZERO

		var tween: Tween = create_tween()
		tween.tween_property(giant_x_label, "scale", Vector2.ONE, 0.5)\
			.set_trans(Tween.TRANS_ELASTIC)
