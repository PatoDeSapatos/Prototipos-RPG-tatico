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
		if ( is_struct(entities[i]) ) {
		    var _x = entities[i].x;
		    var _y = entities[i].y;

			map[_x][_y] = entities[i];	
		}
	}
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

request_post_player_in_battle();
alarm[0] = waiting_time;