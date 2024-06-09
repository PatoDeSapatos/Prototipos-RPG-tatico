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

for (var _x = 0; _x < width; ++_x) {
    for (var _y = 0; _y < height; ++_y) {

		var tile = grid[# _x, _y]
		if (is_undefined(tile)) continue;

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