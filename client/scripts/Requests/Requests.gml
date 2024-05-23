 function request_post_new_player() {
	var _url = string_concat(url, "/player/save/teste");
	var _header = ds_map_create();
	ds_map_add(_header, "Content-Type", "application/json");
	
	requests.post_new_player[0] = http_request(_url, "POST", _header, "");
	ds_map_destroy(_header);
}

function request_post_player_in_battle() {
	var _url = string_concat(url, "/battle/0/add/", playerId);
	var _header = ds_map_create();
	ds_map_add(_header, "Content-Type", "application/json");
	
	requests.post_player_in_battle[0] = http_request(_url, "POST", _header, "");	
	ds_map_destroy(_header);
}

function request_post_turn_action() {
	if ( !is_struct(changed_entity) ) return;
	var _url = string_concat(url, "/battle/0/turnAction");
	var _header = ds_map_create();
	ds_map_add(_header, "Content-Type", "application/json");
	
	var _body = ds_map_create();
	ds_map_add(_body, "entities", [changed_entity]);
	ds_map_add(_body, "playerId", playerId);

	requests.post_turn_action[0] = http_request(_url, "POST", _header, json_encode(_body));
	ds_map_destroy(_header);
	ds_map_destroy(_body);
}

function request_get_game_state() {
	var _url = string_concat(url, "/battle/0/state");
	requests.get_game_state[0] = http_get(_url);
}

function request_post_player_ready() {
	var _url = string_concat(url, "/battle/0/", playerId, "/ready");
	var _header = ds_map_create();
	ds_map_add(_header, "Content-Type", "application/json");
	
	requests.post_player_ready[0] = http_request(_url, "POST", _header, "");
	ds_map_destroy(_header);	
}
