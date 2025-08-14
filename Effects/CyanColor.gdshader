shader_type canvas_item;

uniform bool active = false;

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 cyan_color = vec4(0.67843137, 0.76470588, 0.90980392, previous_color.a);;
	vec4 new_color = previous_color;
	if (active == true) {
		new_color = cyan_color;
	}
	COLOR = new_color;
}