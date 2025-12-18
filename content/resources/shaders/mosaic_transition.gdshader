shader_type canvas_item;

// Retro Boot-up Shader
// Uses a pixel_size factor to create discrete blocking steps.

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// 1.0 = Native resolution, 8.0 = 8x8 pixel blocks
uniform float pixel_size : hint_range(1.0, 128.0) = 1.0;

void fragment() {
	// 1. Get absolute screen resolution
	vec2 screen_res = 1.0 / SCREEN_PIXEL_SIZE;

	// 2. Map UV to absolute pixel coordinates
	vec2 pixel_coord = SCREEN_UV * screen_res;

	// 3. Quantize to the nearest "block"
	vec2 grid_coord = floor(pixel_coord / pixel_size) * pixel_size;

	// 4. Map back to UV space
	vec2 final_uv = grid_coord / screen_res;

	// 5. Center sample to avoid edge artifacts
	vec2 half_pixel = (vec2(pixel_size) / screen_res) * 0.5;

	COLOR = texture(screen_texture, final_uv + half_pixel);
}