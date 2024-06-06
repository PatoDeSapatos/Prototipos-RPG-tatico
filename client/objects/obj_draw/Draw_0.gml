var mouse_tilled_x = screenToTileX(mouse_x, mouse_y)
var mouse_tilled_y = screenToTileY(mouse_x, mouse_y)

var player_bottom_x = screenToTileX(obj_iso_player.x, obj_iso_player.y)
var player_bottom_y = screenToTileY(obj_iso_player.x, obj_iso_player.y)

selected = grid[# mouse_tilled_x, mouse_tilled_y]
player_bottom = grid[# player_bottom_x, player_bottom_y]

for (var _x = 0; _x < width; ++_x) {
    for (var _y = 0; _y < height; ++_y) {

		var tile = grid[# _x, _y]
		if (is_undefined(tile)) continue;

		var sprite = tile.spr
		var z = tile.z
		if (tile == selected) {
			sprite = 0
		} else if (tile == player_bottom) {
			sprite = 2
		}

		draw_sprite_ext(spr_dungeon_tileset, sprite, tileToScreenX(_x, _y), tileToScreenY(_x, _y) + z, scale, scale, 0, c_white, 1)
	}
}

selected = -1
player_bottom = -1