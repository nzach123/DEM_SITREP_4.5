shader_type canvas_item;

// The amount of blur (LOD level). 
// 0.0 is sharp, 5.0 is very blurry.
uniform float lod: hint_range(0.0, 5.0) = 2.0;

// Access the screen texture. 
// 'filter_linear_mipmap' is CRITICAL for the hardware blur to work.
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    // textureLod samples a lower-resolution version (mipmap) of the screen
    vec4 color = textureLod(screen_texture, SCREEN_UV, lod);
    
    // Optional: Add a tint (e.g., darken the background slightly)
    COLOR = color;
}