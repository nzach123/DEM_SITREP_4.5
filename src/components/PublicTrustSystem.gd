class_name PublicTrustSystem
extends Control

signal trust_depleted
signal trust_changed(new_val: float)
signal trust_damaged(amount_lost: float)
signal trust_healed(amount_gained: float)

# Configuration
@export_group("Settings")
@export var max_trust: float = 100.0
@export var critical_threshold: float = 30.0 # When bar turns red/danger

# Nodes
@onready var progress_bar: TextureProgressBar = $TrustBar
@onready var label: Label = $TrustBar/Label
@onready var anim: AnimationPlayer = $AnimationPlayer # Optional for shake

var current_trust: float
var _original_bar_pos: Vector2

func _ready() -> void:
	current_trust = max_trust
	if progress_bar:
		_original_bar_pos = progress_bar.position
	_update_ui(false)

func damage_trust(amount: float) -> void:
	if current_trust <= 0: return

	current_trust = clamp(current_trust - amount, 0.0, max_trust)

	emit_signal("trust_damaged", amount)
	emit_signal("trust_changed", current_trust)

	_update_ui(true)

	if current_trust <= 0:
		emit_signal("trust_depleted")

func heal_trust(amount: float) -> void:
	if current_trust >= max_trust or current_trust <= 0: return # Don't heal if dead or full

	current_trust = clamp(current_trust + amount, 0.0, max_trust)

	emit_signal("trust_healed", amount)
	emit_signal("trust_changed", current_trust)

	_update_ui(true)

func _update_ui(animate: bool) -> void:
	# Tween the value for smooth visual depletion
	if progress_bar:
		var tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
		tween.tween_property(progress_bar, "value", current_trust, 0.4)

		# Color coding
		if current_trust <= critical_threshold:
			progress_bar.tint_progress = Color.RED
		else:
			progress_bar.tint_progress = Color("00a8f3") # DEM Blue

	# Shake effect on damage (only if animate is true and trust went down, strictly speaking damage_trust calls this with true)
	if animate and current_trust < max_trust:
		_play_shake()

func _play_shake() -> void:
	if not progress_bar: return
	
	var tween = create_tween()
	for i in range(5):
		var offset = Vector2(randf_range(-5, 5), randf_range(-5, 5))
		tween.tween_property(progress_bar, "position", _original_bar_pos + offset, 0.05)
	tween.tween_property(progress_bar, "position", _original_bar_pos, 0.05)
