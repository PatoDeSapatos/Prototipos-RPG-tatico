global.controls = {
	key_up: [ord("W"), vk_up],
	key_down: [ord("S"), vk_down],
	key_left: [ord("A"), vk_left],
	key_right: [ord("D"), vk_right]
}

function Input(_key_name) constructor {
	value = false;
	key_name = _key_name;
}

inputs = {
	input_up: new Input("key_up"),
	input_down: new Input("key_down"),
	input_left: new Input("key_left"),
	input_right: new Input("key_right")
}

up = -1;
down = -1;
left = -1;
right = -1;



hspd = -1;
vspd = -1;
spd = 5;

