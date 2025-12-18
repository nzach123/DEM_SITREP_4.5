shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float intensity : hint_range(0.0, 1.0) = 0.0;
uniform float spread : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    // Calculate distance from center (0.5, 0.5)
    vec2 uv = UV - vec2(0.5);

    // Use rectangular distance (max of absolute x and y) for box-like edges
    // or length(uv) for circular vignette.
    // Let's use a mix or just length for a smoother "glow".
    // For "along the edges", a rectangular mask is often better.

    float dist_x = abs(uv.x);
    float dist_y = abs(uv.y);

    // Combine to get a soft rectangular shape
    float dist = max(dist_x, dist_y * (1.0 - spread * 0.5)); // Adjust aspect slightly if needed

    // Circular usually looks better for "danger pulse" even on rectangular screens
    // But let's try a modified box sdf for "edges".

    // Simple vignette:
    float vignette = length(uv);

    // Smoothstep to create the glow at edges
    float alpha = smoothstep(0.5 - spread, 0.7, vignette);

    COLOR = vec4(color.rgb, alpha * intensity * color.a);
}
