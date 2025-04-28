shader_type canvas_item;
render_mode blend_mix, unshaded, skip_vertex_transform;

uniform sampler2D gradient;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;
uniform sampler2D noise_texture : repeat_enable;

uniform float spread_speed = 1.0;
uniform float start_time;
uniform float scene_time;
uniform vec2 player_position;
uniform bool dreaming = false;

//Bigger radius == goes "deeper"
uniform float shader_radius_minimum : hint_range(1.0, 2.0, 0.01) = 1.5;
uniform float vignette_radius_minimum : hint_range(0.8, 1.8, 0.01) = 1.2;

//Bigger == faster
uniform float dream_in_speed : hint_range(0.0, 2.0, 0.1) = 0.9;	
uniform float dream_out_speed : hint_range(0.0, 1.0, 0.1) = 0.0;

uniform float vignette_intensity = 1.0;
uniform float noise_intensity = 6.0;	//Smaller == more intense


const float edge_softness = 1.0;

vec4 dream(vec2 uv, float elapsed_time, float dist) {
    float shader_radius = min(elapsed_time * spread_speed, shader_radius_minimum);
    float vignette_radius = min(elapsed_time, vignette_radius_minimum);

    float mask = 1.0 - smoothstep(shader_radius - edge_softness, shader_radius, 1.0 - dist);
    float mask2 = 1.0 - smoothstep(vignette_radius - edge_softness, vignette_radius, 1.0 - dist);

    vec3 noise_color = texture(noise_texture, uv + (elapsed_time / noise_intensity)).rgb;
    vec2 uv_offset = vec2(noise_color.b / 120.0);

    vec4 originalColor = texture(screen_texture, uv);
    vec3 distorted_color = texture(screen_texture, uv + uv_offset).rgb;
    float brightness = dot(distorted_color.rgb, vec3(0.333));
    vec4 gradientColor = texture(gradient, vec2(brightness, 0.0));

    vec4 vig_color = vec4(0.0, 0.0, 0.0, vignette_intensity);

    vec4 finalColor = mix(originalColor, gradientColor, mask);
    finalColor = mix(finalColor, vig_color, mask2);

    return finalColor;
}

vec4 reverse(vec2 uv, float elapsed_time, float dist) {
    float shader_radius = max(shader_radius_minimum - elapsed_time * spread_speed, 0.0);
	float vignette_radius = min(vignette_radius_minimum - elapsed_time, vignette_radius_minimum);

    float mask = 1.0 - smoothstep(shader_radius - edge_softness, shader_radius, 1.0 - dist);
	float mask2 = 1.0 - smoothstep(vignette_radius - edge_softness, vignette_radius, 1.0 - dist);

    vec4 originalColor = texture(screen_texture, uv);
	vec3 noise_color = texture(noise_texture, uv + (elapsed_time / noise_intensity)).rgb;
    vec2 uv_offset = vec2(noise_color.b / 120.0);
	vec3 distorted_color = texture(screen_texture, uv + uv_offset).rgb;
	float brightness = dot(distorted_color.rgb, vec3(0.333));
    vec4 gradientColor = texture(gradient, vec2(brightness, 0.0));
	vec4 vig_color = vec4(0.0, 0.0, 0.0, vignette_intensity);
    vec4 finalColor = mix(originalColor, gradientColor, mask);
    finalColor = mix(finalColor, vig_color, mask2);

    return finalColor;
}

void fragment() {
    float elapsed_time = scene_time - start_time;
    vec2 center = vec2(0.5); // Or normalize(player_position) if tracking
    float dist = length(SCREEN_UV - center);

    if (elapsed_time < 0.0) {
        discard;
    }
	if(dreaming) COLOR = dream(SCREEN_UV, elapsed_time + dream_in_speed, dist);
	else if(!dreaming) COLOR = reverse(SCREEN_UV, elapsed_time + dream_out_speed, dist);
}
