/// @description
if (!instance_exists(obj_battle_manager)) {	
	instance_destroy();
	return;
}

can_draw = !battle_check_animating() && obj_battle_manager.state == battle_state_turn || obj_battle_manager.state == battle_state_extra;

if (can_draw) {
	// Mouse
	if (hover_option != noone && hover_option.able && variable_instance_get(obj_battle_manager, "l_click")) {
		exit_state_turn(hover_option.state);
		return;
	}

	// Keyboard
	for (var i = 0; i < array_length(options); ++i) {
	    if( options[i].able && keyboard_check_pressed(options[i].key) ) {
			exit_state_turn(options[i].state);
			break;
		}
	}
	
	// Other controls
	for (var i = 0; i < array_length(controls); ++i) {
	    if (variable_instance_get(obj_battle_manager, controls[i].input_name)) {
			controls[i].state();
			break;
		}
	}
}
