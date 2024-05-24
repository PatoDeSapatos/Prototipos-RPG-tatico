function state_choosing() {
	if (array_length(entities) <= 0) return;
	update_map();
	
	if ( my_turn && mouse_check_button_pressed(mb_left) ) {
		if ( selected_grid.x == -1 || selected_grid.y == -1 ) return;
		changed_entity = new Entity(global.playerId, entities[turn].sprite, entities[turn].x, entities[turn].y, selected_grid.x, selected_grid.y);
		request_post_turn_action();
		alarm[0] = waiting_time;
		state = state_waiting;
	}
}

function state_waiting() {
	if ( revised_turn ) {
		request_get_game_state();
		state = state_move_char;
	}
}

function state_move_char() {
	update_map();
	
	alarm[1] = waiting_time;
	state = state_ready;
}

function state_ready() {
	if ( !revised_turn ) {
		state = state_choosing;	
	}
}