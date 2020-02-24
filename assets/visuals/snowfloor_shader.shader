shader_type canvas_item;
//render_mode unshaded;

uniform sampler2D gradient : hint_black;
uniform float mix_amount = 1.0;

void fragment() {
	vec4 og_texture = textureLod(TEXTURE, UV, 0.0);
	vec4 gradient_texture = textureLod(gradient, SCREEN_UV, 0.0);
	
	og_texture = mix(og_texture, gradient_texture, mix_amount);
	
	COLOR = og_texture;
	//COLOR = textureLod(SCREEN_TEXTURE, vec2(uv.x,uv.y), 0.0);
}

void vertex() {
}