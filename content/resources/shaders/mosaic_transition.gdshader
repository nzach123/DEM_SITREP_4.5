shader_type canvas_item;

// Simple Mosaic/Pixelation Shader for Scene Transitions
// Uses SCREEN_TEXTURE to pixelate the underlying scene.

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 resolution = vec2(64.0, 36.0); // Start with low resolution

void fragment() {
	vec2 uv = SCREEN_UV;

	// Quantize UVs to simulate lower resolution
	uv = floor(uv * resolution) / resolution;

	COLOR = texture(screen_texture, uv);
}
