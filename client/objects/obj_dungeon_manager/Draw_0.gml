/// @description
var mouse_tilled_x = screenToTileX(mouse_x, mouse_y)
var mouse_tilled_y = screenToTileY(mouse_x, mouse_y)

if ( instance_exists(obj_player) ) {
	var player_bottom_x = screenToTileX(obj_player.x, obj_player.y) - 1
	var player_bottom_y = screenToTileY(obj_player.x, obj_player.y) - 1
	player_bottom = grid[# player_bottom_x, player_bottom_y];
}

if ((mouse_tilled_x > 0 && mouse_tilled_x < width) && (mouse_tilled_y > 0 && mouse_tilled_y < height)) {
	selected = grid[# mouse_tilled_x, mouse_tilled_y];
}

var camX = screenToTileX(global.camera.camera_x, global.camera.camera_y)
var camY = screenToTileY(global.camera.camera_x, global.camera.camera_y)
var camW = screenToTileX(global.camera.camera_x + global.camera.camera_w, global.camera.camera_y + global.camera.camera_h)
var camH = camY + 1 + (camW - camX) / 2
camY -= (camW - camX) / 2

var _min_x = max(0, camX - 1);
var _max_x = min(width, camW + 1);

var _min_y = max(0, camY - 1);
var _max_y = min(height, camH + 1);

for (var _y = _min_y; _y < _max_y; _y++) {
    for (var _x = _min_x; _x < _max_x; _x++) {

		var tile = grid[# _x, _y];
		if (is_undefined(tile)) continue

		var sprite = tile.spr
		if (tile == selected) {
			sprite = 0
		}/*else if (tile == player_bottom) {
			sprite = 2
		}*/

		draw_sprite_ext(spr_dungeon_tileset, sprite, tileToScreenX(_x, _y), tileToScreenY(_x, _y) + tile.z, scale, scale, 0, c_white, 1)
	}
}

selected = -1
player_bottom = -1