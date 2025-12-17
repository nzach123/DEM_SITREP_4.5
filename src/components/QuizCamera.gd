extends Camera2D
class_name QuizCamera

@export var shake_decay: float = 5.0

var shake_strength: float = 0.0
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shake_decay * delta)
		offset = Vector2(
			rng.randf_range(-shake_strength, shake_strength),
			rng.randf_range(-shake_strength, shake_strength)
		)

func apply_shake(intensity: float) -> void:
	shake_strength = intensity

func apply_shake_bonus(save_weight: int) -> void:
	var shake_bonus: float = 0.0
	if save_weight > 10000:
		shake_bonus = 10.0
	elif save_weight > 1000:
		shake_bonus = 5.0
	elif save_weight > 100:
		shake_bonus = 2.0

	apply_shake(5.0 + shake_bonus)

func apply_casualty_shake() -> void:
	apply_shake(10.0)
