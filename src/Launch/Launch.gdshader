shader_type canvas_item;

void vertex() {

    //VERTEX = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	//VERTEX = UV;
	//UV = VERTEX;
}
void fragment() {
	vec2 norm = UV * 2.0 - 1.0;
	
	// ff3e12
	vec2 x = abs(norm);
	//vec2 x = abs(SCREEN_UV * 2.0 - 1.0);
	float on_edge = step(.98, max(x.x, x.y));
	
	float alpha = on_edge;
	
	mat2 l = mat2(vec2(1.0, -1.0), vec2(1.0, 1.0));
	
	float on_stripe = step(sin((l*norm).x * 100.0 + TIME * 10.0), -.5);
	alpha *= on_stripe;
	
	vec3 color = mix(vec3(1.0), vec3(1.0, 0.0, 0.0), on_stripe * on_edge);
	COLOR = vec4(color, alpha + .1);
	//COLOR = vec4(SCREEN_UV.xyx * 1.0, 1.0);
	
	
}
