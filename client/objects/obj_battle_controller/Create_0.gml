function Entity(_id, _player_id, _sprite, _old_x, _old_y, _x, _y) constructor {
	id = _id;
	playerId = _player_id;
	sprite = _sprite;
	oldX = _old_x;
	oldY = _old_y;
	x = _x;
	y = _y;
}

function update_map() {
	for (var i = 0; i < array_length(entities); ++i) {
		if ( is_struct(entities[i]) ) {
		    var _x = entities[i].x;
		    var _y = entities[i].y;

			map[_x][_y] = entities[i];	
		}
	}
}

function update_game_state( _game_state ) {
	_game_state = json_parse( json_encode(_game_state) );
	if ( is_struct(_game_state) ) {
		game_state = _game_state;
		map = game_state.scenario;
		width = array_length(map);
		height = array_length(map[0]);
		entities = game_state.entities;
		turn = game_state.turn;
		revised_turn = game_state.revisedTurn;
		my_turn = entities[turn].playerId == global.playerId;
	}
}

function set_turn_action() {
	if ( !is_struct(changed_entity) ) return;
	
	var _data = {
		"entities": [changed_entity],
		"battleId": 0,
		"playerId": global.playerId
	}
	
	send_websocket_message("SET_TURN_ACTION", _data);
}

function set_player_ready() {
	var _data = {"battleId": 0, "playerId": global.playerId}
	send_websocket_message("SET_PLAYER_READY", _data);
}

function get_battle_state() {
	var _data = {"battleId": 0}
	send_websocket_message("GET_BATTLE_STATE", _data)
}

state = state_choosing;

tile_size = 64;
border = tile_size/2;
width = floor((room_width - border*2)/tile_size);
height = floor((room_height - border*2)/tile_size);

entities = [];
changed_entity = -1;
map = -1
waiting_time = 30;

game_state = -1;
revised_turn = false;
my_turn = false;
turn = 0;

selected_grid = {
	x: -1,
	y: -1
}
alarm[0] = waiting_time;