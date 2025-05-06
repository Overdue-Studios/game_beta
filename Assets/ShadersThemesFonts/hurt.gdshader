shader_type canvas_item;

uniform float whiteout : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D noise_tex;
uniform float noise_intensity = 6.0;

void fragment() {
    vec2 uv = UV;

    // Glitchy tearing: shift horizontal stripes randomly
    float glitch_band = step(0.9, fract(UV.y * 20.0 + TIME * 10.0)); // flickering horizontal stripes
    float noise = texture(noise_tex, UV * 5.0 + vec2(TIME * 2.0, 0.0)).r;
    uv.x += glitch_band * (noise - 0.5) * 0.1 * whiteout/1.5; // pixel shift only

    vec4 tex_color = texture(TEXTURE, uv);

    // Uniform whiteout (not noise-masked)
    vec3 final_color = mix(tex_color.rgb, vec3(1.0), whiteout);

    COLOR = vec4(final_color, tex_color.a);

}
