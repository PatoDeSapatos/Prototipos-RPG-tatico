function Entity(_player_id, _sprite, _old_x, _old_y, _x, _y) constructor {
	playerId = _player_id;
	sprite = _sprite;
	oldX = _old_x;
	oldY = _old_y;
	x = _x;
	y = _y;
}

function update_map() {
	for (var i = 0; i < array_length(entities); ++i) {
	    var _x = entities[i].x;
	    var _y = entities[i].y;

		map[_x][_y] = entities[i];	
	}
}

global.loading = false;
state = state_choosing;

tile_size = 64;
border = tile_size/2;
width = floor((room_width - border*2)/tile_size);
height = floor((room_height - border*2)/tile_size);

url = "http://localhost:8080";
playerId = 0;
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

requests = {
	post_new_player: [-1, set_new_player],
	post_player_in_battle: [-1, set_player_in_batle],
	post_turn_action: [-1, set_turn_action],
	post_player_ready: [-1, set_player_ready],
	get_game_state: [-1, set_game_state]
}

request_post_player_in_battle();
alarm[0] = waiting_time;