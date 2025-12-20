extends CanvasLayer
class_name SceneTransitionManager

# SceneTransition.gd
# Handles the retro "Boot-up" pixelation effect with discrete steps.

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

	# If you want it to run automatically on game launch:
	# play_boot_sequence()

# Call this function to start the transition
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

# Helper for manual control if needed
func set_pixel_size(size: float) -> void:
	var mat = color_rect.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("pixel_size", size)
