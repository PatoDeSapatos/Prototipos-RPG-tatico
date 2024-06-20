/// @description Inserir descrição aqui
if ( instance_exists(obj_player) ) {
	var player_bottom_x = screenToTileX(obj_player.x, obj_player.y) - 1;
	var player_bottom_y = screenToTileY(obj_player.x, obj_player.y) - 1;
	obj_player.depth = -(tileToScreenY(player_bottom_x, player_bottom_y));
	player_bottom = grid[# player_bottom_x, player_bottom_y];
}

var mouse_tilled_x = screenToTileX(mouse_x, mouse_y)
var mouse_tilled_y = screenToTileY(mouse_x, mouse_y)

if ((mouse_tilled_x > 0 && mouse_tilled_x < width) && (mouse_tilled_y > 0 && mouse_tilled_y < height)) {
	selected = grid[# mouse_tilled_x, mouse_tilled_y];
}