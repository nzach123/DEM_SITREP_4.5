extends CanvasLayer
class_name SceneTransitionManager

# SceneTransition.gd
# Handles the retro "Boot-up" pixelation effect with discrete steps.

## Emitted when screen is fully obscured (safe to swap scenes).
signal transition_halfway
## Emitted when boot sequence animation completes.
signal transition_complete

@onready var color_rect: ColorRect = $ColorRect

# Resolution Divisors (1.0 = Full, 2.0 = Half, 8.0 = Eighth)
const RES_EIGHTH: float = 8.0
const RES_QUARTER: float = 4.0
const RES_HALF: float = 2.0
const RES_FULL: float = 1.0

# Timing Configuration (Total Duration: ~0.5s)
const TIME_STEP_1: float = 0.15
const TIME_STEP_2: float = 0.15
const TIME_STEP_3: float = 0.10
const TIME_TWEEN: float  = 0.10

func _ready() -> void:
	layer = 128
	visible = false # Hidden by default until requested


## Covers the screen with pixelation, emits transition_halfway, then animates to clarity.
## Callers should `await SceneTransition.transition_halfway` before swapping scenes.
func cover_screen() -> void:
	if not is_inside_tree(): return
	visible = true
	var mat = color_rect.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("pixel_size", RES_EIGHTH)
	# Defer signal to next frame so await can connect before emission
	call_deferred("emit_signal", "transition_halfway")


func play_boot_sequence() -> void:
	if not is_inside_tree(): return

	visible = true
	var mat = color_rect.material as ShaderMaterial
	if not mat:
		push_error("SceneTransition: No ShaderMaterial on ColorRect!")
		return

	# Use a single Tween for safety (stops if node is freed)
	var tween = create_tween()

	# --- Step 1: Eighth Resolution ---
	tween.tween_callback(func(): mat.set_shader_parameter("pixel_size", RES_EIGHTH))
	tween.tween_interval(TIME_STEP_1)

	# --- Step 2: Quarter Resolution ---
	tween.tween_callback(func(): mat.set_shader_parameter("pixel_size", RES_QUARTER))
	tween.tween_interval(TIME_STEP_2)

	# --- Step 3: Half Resolution ---
	tween.tween_callback(func(): mat.set_shader_parameter("pixel_size", RES_HALF))
	tween.tween_interval(TIME_STEP_3)

	# --- Step 4: Short Tween to Full Clarity ---
	tween.tween_method(
		func(val): mat.set_shader_parameter("pixel_size", val),
		RES_HALF,
		RES_FULL,
		TIME_TWEEN
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	
	# Cleanup
	tween.tween_callback(hide)
	tween.tween_callback(transition_complete.emit)

func set_pixel_size(size: float) -> void:
	var mat = color_rect.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("pixel_size", size)
