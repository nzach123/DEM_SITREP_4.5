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
	visible = true
	var mat = color_rect.material as ShaderMaterial
	if not mat:
		push_error("SceneTransition: No ShaderMaterial on ColorRect!")
		return

	# --- Step 1: Eighth Resolution ---
	mat.set_shader_parameter("pixel_size", RES_EIGHTH)
	await get_tree().create_timer(TIME_STEP_1).timeout

	# --- Step 2: Quarter Resolution ---
	mat.set_shader_parameter("pixel_size", RES_QUARTER)
	await get_tree().create_timer(TIME_STEP_2).timeout

	# --- Step 3: Half Resolution ---
	mat.set_shader_parameter("pixel_size", RES_HALF)
	await get_tree().create_timer(TIME_STEP_3).timeout

	# --- Step 4: Short Tween to Full Clarity ---
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_method(
		func(val): mat.set_shader_parameter("pixel_size", val),
		RES_HALF,
		RES_FULL,
		TIME_TWEEN
	)
	
	# Cleanup
	tween.tween_callback(hide)

# Helper for manual control if needed
func set_pixel_size(size: float) -> void:
	var mat = color_rect.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("pixel_size", size)
