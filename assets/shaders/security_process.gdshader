shader_type canvas_item;

uniform float line_thickness : hint_range(1.0, 10.0) = 5.0; // Thickness of the scan lines
uniform float speed : hint_range(0.0, 10.0) = 1.0;          // Speed of the animation
uniform vec4 line_color = vec4(0.0, 1.0, 0.0, 0.5); // Color of the scan lines
uniform vec4 fov_color = vec4(0.4, 1.0, 1.0, 0.3); // Base field of view color

void fragment() {
    vec2 uv = UV; // UV coordinates for the FOV shape
    float time_factor = mod(TIME * speed, 1.0); // Animated offset for lines

    // Generate scan lines by creating a stripe pattern
    float line_pattern = step(0.5, abs(fract(uv.y * line_thickness + time_factor) - 0.5));

    // Blend FOV color with scan lines
    vec4 base = fov_color;
    vec4 lines = line_color * line_pattern;
    COLOR = mix(base, lines, lines.a); // Only show lines where `line_color.a` is non-zero
	COLOR = base;
}
