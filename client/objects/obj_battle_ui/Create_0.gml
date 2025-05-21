/// @description
function battle_option(_name, _state, _input_name, _key, _console_key, _angle) constructor {
	name = _name;	
	state = _state;
	input_name = _input_name;
	key = _key;
	console_key = _console_key;
	angle = _angle;
	
	able = true;
}

// Options
options = [
	new battle_option("Move", battle_start_state_move, "move_input", ord("S"), noone, 270),
	new battle_option("Guard", battle_state_guard, "move_input", ord("A"), noone, 330),
	new battle_option("Item", battle_start_state_item, "item_input", ord("E"), noone, 210),
	new battle_option("Skills", battle_start_state_skills, "skills_input", ord("W"), noone, 10),
	new battle_option("Attack", battle_state_attack, "attack_input", ord("Q"), noone, 170),
	
	new battle_option("Pass", battle_set_state_extra_choosing, "pass_input", ord("G"), noone, 90)
];

controls = [
	new battle_option("End Turn", battle_skip_turn, "skip_input", ord("R"), noone, 0),
	new battle_option("Free Camera", battle_set_free_camera, "move_camera_input", ord("M"), noone, 0),
	new battle_option("Inspect", battle_set_state_interact, "interact_input", ord("F"), noone, 0),
]

scale = obj_battle_manager.scale;
distance = 37 * scale;
option_border = 10 * scale;
hover_option = noone;
can_draw = false;
show_desc = false;

inventory = noone;