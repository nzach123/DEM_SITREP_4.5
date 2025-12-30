extends Node2D
class_name BackgroundPulse

@onready var bg_alarm_05: TextureRect = $AlarmTextureRect
@onready var bg_low_a: TextureRect = $AlarmLowATextureRect
@onready var bg_low_b: TextureRect = $AlarmLowBTextureRect
@onready var bg_high_a: TextureRect = $AlarmHighATextureRect
@onready var bg_high_b: TextureRect = $AlarmHighBTextureRect

var bg_tween: Tween
var current_strikes: int = 0

func _ready() -> void:
	# Ensure initial state is clean
	var all_alarms: Array[TextureRect] = [bg_alarm_05, bg_low_a, bg_low_b, bg_high_a, bg_high_b]
	for node in all_alarms:
		node.modulate.a = 0.0

func update_pulse(strikes: int) -> void:
	current_strikes = strikes
	_start_pulse_sequence()

func _start_pulse_sequence() -> void:
	if bg_tween:
		bg_tween.kill()

	bg_tween = create_tween()

	var all_alarms: Array[TextureRect] = [bg_alarm_05, bg_low_a, bg_low_b, bg_high_a, bg_high_b]

	# Determine candidate pool based on strikes
	var candidates: Array[TextureRect] = []
	if current_strikes == 0:
		candidates = [bg_alarm_05]
	elif current_strikes == 1:
		candidates = [bg_low_a, bg_low_b]
	else:
		# 2 or more strikes
		candidates = [bg_high_a, bg_high_b]

	var target_node: TextureRect = candidates.pick_random()

	for node in all_alarms:
		if node != target_node:
			node.modulate.a = 0.0

	var fade_in_time: float = 1.0
	var fade_out_time: float = 1.0

	if current_strikes >= 2:
		fade_in_time = 0.5
		fade_out_time = 0.5

	bg_tween.tween_property(target_node, "modulate:a", 1.0, fade_in_time).from(0.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	bg_tween.tween_property(target_node, "modulate:a", 0.0, fade_out_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	bg_tween.tween_callback(_start_pulse_sequence)
