extends CanvasLayer
class_name SceneTransitionManager

# SceneTransition.gd
# Handles the retro "Boot-up" pixelation effect.

@onready var color_rect: ColorRect = $ColorRect

# Initial low resolution (blocky)
const START_RES: Vector2 = Vector2(0.1, 0.1)

# Duration of the resolve effect
const DURATION: float = 1.5

func _ready() -> void:
	# Ensure the transition layer is on top of everything
	layer = 128

	# "App Launch" effect:
	# The overlay should be visible and pixelated immediately.
	cover()

	# Wait a brief moment for the app to settle, then resolve
	await get_tree().process_frame
	resolve()

func cover() -> void:
	visible = true
	var mat: ShaderMaterial = color_rect.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("resolution", START_RES)

func resolve() -> void:
	var mat: ShaderMaterial = color_rect.material as ShaderMaterial
	if not mat:
		return

	var target_res: Vector2 = get_viewport().get_visible_rect().size

	# Tween the resolution from current (Low) to Target (High/Native)
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR) # Exponential makes it feel like it's "focusing" faster at the end
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_method(_set_shader_resolution, START_RES, target_res, DURATION)

	# Hide after completion to save performance
	tween.tween_callback(hide)

func _set_shader_resolution(res: Vector2) -> void:
	var mat: ShaderMaterial = color_rect.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("resolution", res)
