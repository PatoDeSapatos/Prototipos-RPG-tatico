function set_game_state() {
	var res = ds_map_find_value(async_load, "result");
	with (obj_battle_controller) {
		game_state = json_parse(res);
		map = game_state.scenario;
		width = array_length(map);
		height = array_length(map[0]);
		entities = game_state.entities;
		turn = game_state.turn;
		revised_turn = game_state.revisedTurn;
		my_turn = entities[turn].playerId == global.playerId;
	}
}

function set_player_in_battle() {
	var res = ds_map_find_value(async_load, "result");
	array_push( obj_battle_controller.entities, json_parse(res) );
	request_get_game_state();
}

function set_new_player() {
	var res = ds_map_find_value(async_load, "result");
	global.playerId = res;
}

function set_new_battle() {
	var res =  ds_map_find_value(async_load, "result");
	global.battleId = res;
	room_goto(rm_battle);
}


function set_turn_action() {

}

function set_player_ready() {
}

function set_player_exists() {
	var res =  ds_map_find_value(async_load, "result");
	if ( !res ) {
		request_post_new_player();
	}
	request_battle_exists();
}

function set_battle_exists() {
	var res =  ds_map_find_value(async_load, "result");
	if ( !res ) {
		request_post_new_battle();
	} else {
		room_goto(rm_battle);	
	}
}