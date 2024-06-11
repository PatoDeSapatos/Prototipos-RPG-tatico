function tileToScreenX(_x, _y) {
	return ((_x - _y) * (obj_dungeon_manager.tile_size / 2)) + obj_dungeon_manager.start_x
}

function tileToScreenY(_x, _y) {
	return ((_x + _y) * (obj_dungeon_manager.tile_size / 4)) + obj_dungeon_manager.start_y
}

function screenToTileX(_x, _y) {
	var screen_x = _x - obj_dungeon_manager.start_x
	var screen_y = _y - obj_dungeon_manager.start_y

	return floor(((screen_x / (obj_dungeon_manager.tile_size / 2)) + (screen_y / (obj_dungeon_manager.tile_size / 4))) / 2)
}

function screenToTileY(_x, _y) {
	var screen_x = _x - obj_dungeon_manager.start_x
	var screen_y = _y - obj_dungeon_manager.start_y

	return floor(((screen_y / (obj_dungeon_manager.tile_size / 4)) - (screen_x / (obj_dungeon_manager.tile_size / 2))) / 2)
}