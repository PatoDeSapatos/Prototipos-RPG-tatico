function set_player_in_battle() {
	var res = ds_map_find_value(async_load, "result");
	array_push( obj_battle_controller.entities, json_parse(res) );
	request_get_game_state();
}

function set_new_player() {
	var res = ds_map_find_value(async_load, "result");
	global.playerId = res;
	
	var Buffer = buffer_create(1, buffer_grow ,1);
	var _data = {
		"playerId": global.playerId,
		"battleId": 0
	}
	
	var _message = ds_map_create();
	ds_map_add(_message, "messageType", "ADD_PLAYER");
	ds_map_add(_message, "data", _data);

	room_goto(rm_battle);
	buffer_write(Buffer , buffer_text  , json_encode(_message));
	network_send_raw(global.socket, Buffer, buffer_tell(Buffer), network_send_text);
	buffer_delete(Buffer)
	ds_map_destroy(_message);
}

function set_new_battle() {
	var res =  ds_map_find_value(async_load, "result");
	global.battleId = res;
	room_goto(rm_battle);
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