/// @description
function Input(_key_name) constructor {
	value = false;
	key_name = _key_name;
}

state = -1;
hspd = -1;
vspd = -1;
_x = x;
_y = y;
spd = 5;
player_username = "";
entity_id = -1;

input_magnitude = -1;
input_direction = -1;

gamepad_id = -1;

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

state_player_free = function () {
	hspd = lengthdir_x(spd * input_magnitude, input_direction);
	vspd = lengthdir_y(spd * input_magnitude, input_direction);
	
	_x += hspd;
	_y += vspd;
}

update_entity_values = function(_new_values) {
	x = struct_get(_new_values, "x");
	y = struct_get(_new_values, "y");
}

state = state_player_free;