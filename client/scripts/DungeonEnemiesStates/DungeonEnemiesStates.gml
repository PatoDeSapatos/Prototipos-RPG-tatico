function enemy_chase_idle() {
	if ( instance_exists(obj_player) && distance_to_object(obj_player) <= range ) {
		state = enemy_chase_walking;
	}
}

function enemy_chase_walking() {
	
	if ( !instance_exists(obj_player) || distance_to_object(obj_player) > range ) {
		state = enemy_chase_idle;
		return;
	}
	
	var _player = instance_nearest(x, y, obj_player);
	
	var _x = screenToTileX(x, y);
    var _y = screenToTileY(x, y);
	
	var _player_x = screenToTileX(_player.x, _player.y);
	var _player_y = screenToTileY(_player.x, _player.y);
	
	if (!moving) {
		var _grid = obj_dungeon_manager.grid;
		
		
		path = get_shortest_path(_grid, _x, _y, _player_x, _player_y, range div obj_dungeon_manager.tile_size);
		if (is_undefined(path) || array_length(path) <= 0) {
			state = enemy_chase_idle;
			return;
		}
	
		target_x = tileToScreenX( path[0, 0], path[0, 1] );
		target_y = tileToScreenY( path[0, 0], path[0, 1] );
		moving = true;
	}
	
	//var _dir = point_direction(_x, _y, target_x, target_y);
	//x += lengthdir_x(spd, _dir);
	//y += lengthdir_y(spd, _dir);
	
	x = approach(x, target_x, spd);
	y = approach(y, target_y, spd);
	
	if ( x == target_x && y == target_y ) {
		moving = false;
	}
}
