extends CanvasLayer
## CRTOverlay: Global CRT post-process shader layer.
## Renders at layer 100 (above GameOverlay at 99).

@onready var crt_rect: ColorRect

var is_enabled: bool = false : set = set_enabled

const CRT_SHADER: Shader = preload("res://content/resources/shaders/crt_screen.gdshader")



func _ready() -> void:
	layer = 100
	visible = is_enabled
	
	# Create fullscreen ColorRect with CRT shader
	crt_rect = ColorRect.new()
	crt_rect.name = "CRTScreen"
	crt_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	crt_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var mat = ShaderMaterial.new()
	mat.shader = CRT_SHADER
	
	# Default shader params (match existing scenes)
	mat.set_shader_parameter("overlay", true)
	mat.set_shader_parameter("scanlines_opacity", 0.2)
	mat.set_shader_parameter("scanlines_width", 0.25)
	mat.set_shader_parameter("grille_opacity", 0.15)
	mat.set_shader_parameter("resolution", Vector2(640, 480))
	mat.set_shader_parameter("pixelate", true)
	mat.set_shader_parameter("brightness", 1.4)
	mat.set_shader_parameter("warp_amount", 0.11)
	mat.set_shader_parameter("vignette_intensity", 0.3)
	mat.set_shader_parameter("vignette_opacity", 0.5)
	mat.set_shader_parameter("aberration", 0.005)
	mat.set_shader_parameter("static_noise_intensity", 0.02)
	mat.set_shader_parameter("roll", true)
	mat.set_shader_parameter("roll_speed", 0.0)
	mat.set_shader_parameter("roll_size", 15.0)
	mat.set_shader_parameter("roll_variation", 1.8)
	mat.set_shader_parameter("distort_intensity", 0.0)
	mat.set_shader_parameter("noise_opacity", 0.0)
	mat.set_shader_parameter("noise_speed", 5.0)
	mat.set_shader_parameter("discolor", true)
	mat.set_shader_parameter("clip_warp", false)
	
	crt_rect.material = mat
	add_child(crt_rect)


## Toggle CRT effect globally
func set_enabled(value: bool) -> void:
	is_enabled = value
	visible = value

## Flash effect for login/boot sequences
func flash_brightness(peak: float = 5.0, duration: float = 0.3) -> void:
	if not is_enabled: return
	
	if crt_rect and crt_rect.material:
		var tween = create_tween()
		tween.tween_property(crt_rect.material, "shader_parameter/brightness", peak, duration * 0.33)
		tween.tween_property(crt_rect.material, "shader_parameter/brightness", 1.4, duration * 0.67)


## Access for direct shader manipulation
func get_material() -> ShaderMaterial:
	if crt_rect:
		return crt_rect.material as ShaderMaterial
	return null
