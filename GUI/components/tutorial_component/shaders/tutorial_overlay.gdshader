shader_type canvas_item;

const int MAX_TARGETS = 8;

uniform int target_count = 0;
uniform vec2 target_positions[MAX_TARGETS];
uniform vec2 target_sizes[MAX_TARGETS];

uniform float feather : hint_range(0.0, 50.0) = 6.0;
uniform float roundness : hint_range(0.0, 1.0) = 0.085;

uniform vec4 border_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float border_width : hint_range(0.0, 50.0) = 3.0;
uniform float blink_speed : hint_range(0.0, 20.0) = 4.0;
uniform float blink_intensity : hint_range(0.0, 1.0) = 0.6;

uniform vec2 overlay_size;

float sdRoundedBox(vec2 p, vec2 b, float r) {
    vec2 q = abs(p) - b + r;
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - r;
}

void fragment() {
    vec2 current_pixel = UV * overlay_size;

    float min_dist = 99999.0;

    for (int i = 0; i < target_count; i++) {
        vec2 center = target_positions[i];
        vec2 size = target_sizes[i];

        vec2 half_size = size * 0.5;
        float radius = roundness * min(half_size.x, half_size.y);

        float dist = sdRoundedBox(
            current_pixel - center,
            half_size,
            radius
        );

        min_dist = min(min_dist, dist);
    }

    float f = max(feather, 0.001);
    float final_mask = smoothstep(-f, f, min_dist);
    
    // Draw pulsing border around the glowing hole
    float edge_outer = smoothstep(border_width - f, border_width + f, min_dist);
    float border_alpha = final_mask - edge_outer;
    
    float blinking = mix(1.0 - blink_intensity, 1.0, (sin(TIME * blink_speed) + 1.0) * 0.5);
    
    // Base mask logic
    vec4 base = COLOR;
    base.a *= final_mask;
    
    // Glowing border logic
    vec4 border = border_color;
    border.a *= max(0.0, border_alpha) * blinking;
    
    // Composite the glowing border over the dark mask backdrop
    COLOR.rgb = mix(base.rgb, border.rgb, border.a);
    COLOR.a = base.a + border.a * (1.0 - base.a);
}
