shader_type canvas_item;

uniform float corrupt_strength : hint_range(0.0, 1.0, 0.01) = 0.4;
uniform float darken_amount : hint_range(0.0, 1.0, 0.01) = 0.2;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    // Invert the colors (negative effect)
    vec3 inverted_color = vec3(1.0) - tex_color.rgb;

    // Add a purple tint
    vec3 purple_tint = vec3(0.5, 0.0, 0.5);

    // Mix the original, inverted, and purple colors based on the corruption strength
    vec3 corrupted_color = mix(tex_color.rgb, mix(inverted_color, purple_tint, 0.5), corrupt_strength);

    // Darken the final color
    vec3 darkened_color = corrupted_color * (1.0 - darken_amount);

    COLOR = vec4(darkened_color, tex_color.a);
}