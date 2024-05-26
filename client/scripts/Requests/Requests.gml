function setup_requests() {
	global.requests = {
		post_new_player: [-1, set_new_player],
		post_new_battle: [-1, set_new_battle],
		get_player_exists: [-1, set_player_exists],
		get_battle_exists: [-1, set_battle_exists]
	}
}

function request_post_new_player(_username) {
	with (obj_game) {
		var _url = string_concat("http://localhost:8080/player/save/", _username);
		var _header = ds_map_create();
		ds_map_add(_header, "Content-Type", "application/json");
		global.requests.post_new_player[0] = http_request(_url, "POST", _header, "");
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