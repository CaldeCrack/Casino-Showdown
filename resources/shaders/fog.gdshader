shader_type canvas_item;

uniform vec3 color = vec3(0.5, 0.5, 0.55);
uniform int OCTAVES = 4;

float rand(vec2 coord){
	coord = mod(coord, 10000.0);
	return fract(sin(dot(coord, vec2(12.9898, 78.233))) * 43758.5453);
}

//vec2 rand2(vec2 coord) {
	//coord = mod(coord, 10000.0);
	//return fract(sin(vec2(dot(coord, vec2(127.1, 311.7)), dot(coord, vec2(269.5, 183.3)))) * 4.0);
//}

float noise(vec2 coord) {
	vec2 i = floor(coord);
	vec2 f = fract(coord);

	float tl = rand(i);
	float tr = rand(i + vec2(1.0, 0.0));
	float bl = rand(i + vec2(0.0, 1.0));
	float br = rand(i + vec2(1.0, 1.0));

	vec2 cubic = f * f * (3.0 - 2.0 * f);

	float topmix = mix(tl, tr, cubic.x);
	float botmix = mix(bl, br, cubic.x);
	float wholemix = mix(topmix, botmix, cubic.y);

	return wholemix;
}

float fbm(vec2 coord) {
	float value = 0.0;
	float scale = 0.5;

	for(int i = 0; i < OCTAVES; i++) {
		value += noise(coord) * scale;
		coord *= 2.0;
		scale *= 0.5;
	}

	return value;
}

void fragment() {
	vec2 coord = UV * 10.0;
	vec2 motion = vec2(fbm(coord + vec2(TIME * -0.25, TIME * 0.25)));
	float final = fbm(coord + motion);
	COLOR = vec4(color, final * 0.75);
}
