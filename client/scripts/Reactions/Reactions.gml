function set_game_state() {
	var res = ds_map_find_value(async_load, "result");
	game_state = json_parse(res);
	map = game_state.scenario;
	width = array_length(map);
	height = array_length(map[0]);
	entities = game_state.entities;
	turn = game_state.turn;
	revised_turn = game_state.revisedTurn;
	my_turn = entities[turn].playerId == playerId;
}

function set_player_in_batle() {
	var res = ds_map_find_value(async_load, "result");
	array_push( entities, json_parse(res) );
	request_get_game_state();
}

function set_new_player() {
	var res = ds_map_find_value(async_load, "result");
	playerId = res;
	request_post_player_in_battle();
}

function set_turn_action() {

}

function set_player_ready() {
}