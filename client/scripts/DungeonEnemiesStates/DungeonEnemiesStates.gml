function enemy_chase_idle() {
	//if ( instance_exists(obj_player) && distance_to_object(obj_player) <= range ) {
		state = enemy_chase_walking;
	//}
}

function enemy_chase_walking() {
	//|| distance_to_object(obj_player) > range
	if ( !instance_exists(obj_player) ) {
		//state = enemy_chase_idle;
		return;
	}
	
	var _player = instance_nearest(x, y, obj_player);
	
	var _grid = obj_dungeon_manager.grid;
	var _x = screenToTileX(x, y);
    var _y = screenToTileY(x, y);
	
	var _player_x = screenToTileX(_player.x, _player.y);
	var _player_y = screenToTileY(_player.x, _player.y);
	
	var _path = get_shortest_path(_grid, _x, _y, _player_x, _player_y);
	if (is_undefined(_path) || array_length(_path) <= 0) return;
	
	if (!moving) {
		target_x = _path[0, 0];
		target_y = _path[0, 1];
	}
	
	var _dir = point_direction(_x, _y, target_x, target_y);
	x += lengthdir_x(spd, _dir);
	y += lengthdir_y(spd, _dir);
	
	if ( x == target_x && y == target_y ) {
		moving = false;
	}
}