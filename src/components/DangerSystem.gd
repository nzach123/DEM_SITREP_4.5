extends Node
class_name DangerSystem

@export var siren_rect: TextureRect
@export var danger_overlay: ColorRect

var _overlay_tween: Tween
var _siren_tween: Tween
var _is_danger_mode: bool = false
var _danger_pulse_speed: float = 1.0

const COLOR_ALERT: Color = Color(1.0, 0.0, 0.0, 1.0) # Red

func _ready() -> void:
	reset_system()

func reset_system() -> void:
	_is_danger_mode = false
	if siren_rect:
		siren_rect.visible = false
		siren_rect.modulate.a = 0.0
	if danger_overlay:
		danger_overlay.visible = true
		var mat = danger_overlay.material as ShaderMaterial
		if mat:
			mat.set_shader_parameter("intensity", 0.0)

	if _overlay_tween: _overlay_tween.kill()
	if _siren_tween: _siren_tween.kill()

func trigger_alert() -> void:
	# Flash Siren Once
	_flash_siren(1.0) # 1.0 = normal speed

	# Pulse Overlay Once (only if not in danger mode)
	if not _is_danger_mode:
		_pulse_overlay_once()

func set_danger_mode(active: bool) -> void:
	if _is_danger_mode == active:
		return

	_is_danger_mode = active

	if _is_danger_mode:
		_start_continuous_pulse()
	else:
		# Stop pulsing and reset overlay
		if _overlay_tween: _overlay_tween.kill()
		var mat = danger_overlay.material as ShaderMaterial
		if mat:
			var tw = create_tween()
			tw.tween_method(func(v): mat.set_shader_parameter("intensity", v),
				mat.get_shader_parameter("intensity"), 0.0, 0.5)

func trigger_failure() -> void:
	_is_danger_mode = false # Stop the heartbeat, switch to failure state if needed, or just let siren take over.
	# The prompt says: "SirensTextureRect enters a continuous flashing state"

	# Stop overlay pulse or keep it? "remains active until the scene changes".
	# User didn't specify overlay behavior on failure, only Siren.
	# But keeping the red overlay at a high intensity might look good.
	# Let's focus on the Siren as requested.

	_flash_siren_continuous()

# --- Internal Animation Helpers ---

func _flash_siren(speed: float) -> void:
	if not siren_rect: return

	if _siren_tween: _siren_tween.kill()
	_siren_tween = create_tween()

	siren_rect.visible = true
	siren_rect.modulate.a = 0.0

	var duration_in = 0.1 / speed
	var duration_out = 0.4 / speed

	_siren_tween.tween_property(siren_rect, "modulate:a", 1.0, duration_in).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	_siren_tween.tween_property(siren_rect, "modulate:a", 0.0, duration_out).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	_siren_tween.tween_callback(func(): siren_rect.visible = false)

func _flash_siren_continuous() -> void:
	if not siren_rect: return

	if _siren_tween: _siren_tween.kill()
	_siren_tween = create_tween().set_loops()

	siren_rect.visible = true

	# Fast strobing for failure
	var duration = 0.5

	_siren_tween.tween_property(siren_rect, "modulate:a", 1.0, duration * 0.5).from(0.0)
	_siren_tween.tween_property(siren_rect, "modulate:a", 0.0, duration * 0.5)

func _pulse_overlay_once() -> void:
	if not danger_overlay: return
	var mat = danger_overlay.material as ShaderMaterial
	if not mat: return

	if _overlay_tween: _overlay_tween.kill()
	_overlay_tween = create_tween()

	# Quick red flash
	_overlay_tween.tween_method(func(v): mat.set_shader_parameter("intensity", v), 0.0, 0.8, 0.2).set_trans(Tween.TRANS_SINE)
	_overlay_tween.tween_method(func(v): mat.set_shader_parameter("intensity", v), 0.8, 0.0, 0.6).set_trans(Tween.TRANS_SINE)

func _start_continuous_pulse() -> void:
	if not danger_overlay: return
	var mat = danger_overlay.material as ShaderMaterial
	if not mat: return

	if _overlay_tween: _overlay_tween.kill()
	_overlay_tween = create_tween().set_loops()

	# Heartbeat style: Fast in, slow out, repeat
	# "Close to losing... increase pulse intensity and flash frequency"
	# We are in danger mode (2 strikes), so use high intensity/frequency

	var high_intensity = 0.9
	var low_intensity = 0.3
	var duration = 0.8 # Faster than normal

	# Pulse Up
	_overlay_tween.tween_method(func(v): mat.set_shader_parameter("intensity", v), low_intensity, high_intensity, duration * 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	# Pulse Down
	_overlay_tween.tween_method(func(v): mat.set_shader_parameter("intensity", v), high_intensity, low_intensity, duration * 0.7).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
