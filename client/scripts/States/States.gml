function state_choosing() {
	if (array_length(entities) <= 0) return;
	update_map();
	if ( my_turn && mouse_check_button_pressed(mb_left) ) {
		if ( selected_grid.x == -1 || selected_grid.y == -1 ) return;
		changed_entity = new Entity(entities[turn].id, global.playerId, entities[turn].sprite, entities[turn].x, entities[turn].y, selected_grid.x, selected_grid.y);
		set_turn_action();
		state = state_waiting;
	} else if (revised_turn) {
		state = state_move_char;
	}
}

function state_waiting() {
	if ( revised_turn ) {
		state = state_move_char;
	}
}

function state_move_char() {
	update_map();
	set_player_ready();
	state = state_ready;
}

function state_ready() {
	if ( !revised_turn ) {
		state = state_choosing;	
	}
}