var mouse_tilled_x = screenToTileX(mouse_x, mouse_y)
var mouse_tilled_y = screenToTileY(mouse_x, mouse_y)

if ( instance_exists(obj_player) ) {
	var player_bottom_x = screenToTileX(obj_player.x, obj_player.y)
	var player_bottom_y = screenToTileY(obj_player.x, obj_player.y)
	player_bottom = grid[# player_bottom_x, player_bottom_y];
}

if ((mouse_tilled_x > 0 && mouse_tilled_x < width) && (mouse_tilled_y > 0 && mouse_tilled_y < height)) {
	selected = grid[# mouse_tilled_x, mouse_tilled_y];
} else {
	selected = -1;	
}

var camX = screenToTileX(global.camera.camera_x, global.camera.camera_y)
var camY = screenToTileY(global.camera.camera_x, global.camera.camera_y)
var camW = screenToTileX(global.camera.camera_x + global.camera.camera_w, global.camera.camera_y + global.camera.camera_h)
var camH = screenToTileY(global.camera.camera_x + global.camera.camera_w, global.camera.camera_y + global.camera.camera_h)

show_debug_message(string("x: {0}, y: {1}, w: {2}, h: {3}", global.camera.camera_x, global.camera.camera_y, global.camera.camera_w, global.camera.camera_h))
show_debug_message(string("x: {0}, y: {1}, w: {2}, h: {3}", camX, camY, camW, camH))

for (var _y = max(0, camY - 1); _y < min(height, camH + 1); _y++) {
    for (var _x = max(0, camX - 1); _x < min(width, camW + 1); _x++) {

		var tile = grid[# _x, _y]
		if (is_undefined(tile)) continue

		var sprite = tile.spr
		var z = tile.z
		if (tile == selected) {
			sprite = 0
		}

		draw_sprite_ext(spr_dungeon_tileset, sprite, tileToScreenX(_x, _y), tileToScreenY(_x, _y) + z, scale, scale, 0, c_white, 1)
	}
}

selected = -1
player_bottom = -1