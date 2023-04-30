shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
void fragment() {
	vec2 from_center = UV / 50.0;// to generalize
	float data = length(from_center);
	vec3 color = vec3(0.0);
	
	float center_offset =max(0.0, 1.0 - data);// for center sphere
	float sin_modif = (sin(data*4.0+TIME) + 1.0)/3.0;
	float distance_fade_off = clamp(1.0 - (data - 1.0) / 3.0, 0.0, 1.0);
	
	vec2 uv = SCREEN_UV - 1e-2 * normalize(UV) * sin(data*4.0+TIME) * distance_fade_off;
	float black = (center_offset + sin_modif) * distance_fade_off;
    COLOR = vec4(mix(textureLod(SCREEN_TEXTURE, uv, 0.0).rgb, vec3(color), black), 1.0);
}

void vertex() {
	UV = VERTEX;
}

void light() {
}