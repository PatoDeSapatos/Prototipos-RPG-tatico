function tileToScreenX(_x, _y) {
	return ((_x - _y) * (obj_draw.tile_size / 2)) + obj_draw.start_x
}

function tileToScreenY(_x, _y) {
	return ((_x + _y) * (obj_draw.tile_size / 4)) + obj_draw.start_y
}

function screenToTileX(_x, _y) {
	var screen_x = _x - obj_draw.start_x
	var screen_y = _y - obj_draw.start_y

	return floor(((screen_x / (obj_draw.tile_size / 2)) + (screen_y / (obj_draw.tile_size / 4))) / 2)
}

function screenToTileY(_x, _y) {
	var screen_x = _x - obj_draw.start_x
	var screen_y = _y - obj_draw.start_y

	return floor(((screen_y / (obj_draw.tile_size / 4)) - (screen_x / (obj_draw.tile_size / 2))) / 2)
}