function setup_requests() {
	global.requests = {
		post_new_player: [-1, set_new_player],
		post_new_battle: [-1, set_new_battle],
		post_player_in_battle: [-1, set_player_in_battle],
		post_turn_action: [-1, set_turn_action],
		post_player_ready: [-1, set_player_ready],
		get_game_state: [-1, set_game_state],
		get_player_exists: [-1, set_player_exists],
		get_battle_exists: [-1, set_battle_exists]
	}
}

function request_post_new_player() {
	with (obj_game) {
		var _url = string_concat(url, "/player/save/teste");
		var _header = ds_map_create();
		ds_map_add(_header, "Content-Type", "application/json");
	
		global.requests.post_new_player[0] = http_request(_url, "POST", _header, "");
		ds_map_destroy(_header);
	}
}

function request_post_player_in_battle() {
	with (obj_game) {
		var _url = string_concat(url, "/battle/", global.battleId, "/add/", global.playerId);
		var _header = ds_map_create();
		ds_map_add(_header, "Content-Type", "application/json");
	
		global.requests.post_player_in_battle[0] = http_request(_url, "POST", _header, "");	
		ds_map_destroy(_header);
	}
}

function request_post_turn_action() {
	with (obj_game) {
		if ( !is_struct(obj_battle_controller.changed_entity) ) return;
		var _url = string_concat(url, "/battle/", global.battleId,"/turnAction");
		var _header = ds_map_create();
		ds_map_add(_header, "Content-Type", "application/json");
	
		var _body = ds_map_create();
		ds_map_add(_body, "entities", [obj_battle_controller.changed_entity]);
		ds_map_add(_body, "playerId", global.playerId);

		global.requests.post_turn_action[0] = http_request(_url, "POST", _header, json_encode(_body));
		ds_map_destroy(_header);
		ds_map_destroy(_body);
	}
}

function request_get_game_state() {
	with (obj_game) {
		var _url = string_concat(url, "/battle/", global.battleId, "/state");
		global.requests.get_game_state[0] = http_get(_url);
	}
}

function request_post_player_ready() {
	with (obj_game) {
		var _url = string_concat(url, "/battle/", global.battleId,"/", global.playerId, "/ready");
		var _header = ds_map_create();
		ds_map_add(_header, "Content-Type", "application/json");
	
		global.requests.post_player_ready[0] = http_request(_url, "POST", _header, "");
		ds_map_destroy(_header);	
	}
}

function request_player_exists() {
	with (obj_game) {
		var _url = string_concat(url, "/player/", global.playerId);
		global.requests.get_player_exists[0] = http_get(_url);
	}
}

function request_battle_exists() {
	with (obj_game) {
		var _url = string_concat(url, "/battle/", global.battleId);
		global.requests.get_battle_exists[0] = http_get(_url);
	}
}

function request_post_new_battle() {
	with (obj_game) {
		var _url = string_concat(url, "/battle/create/", global.playerId);
		var _header = ds_map_create();
		ds_map_add(_header, "Content-Type", "application/json");
	
		var _body = ds_map_create();
		ds_map_add(_body, "width", 5);
		ds_map_add(_body, "height", 5);
		
		global.requests.post_new_battle[0] = http_request(_url, "POST", _header, _body);
	}
}