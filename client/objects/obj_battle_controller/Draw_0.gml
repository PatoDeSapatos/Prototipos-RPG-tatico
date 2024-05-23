/// @description Insert description here
if (map != -1) {
	update_map();
	for (var i = 0; i < array_length(map); ++i) {
		for (var j = 0; j < array_length(map[0]); ++j) {
			var _x1 = i*tile_size + border + 1;
			var _y1 = j*tile_size + border + 1;
			var _x2 = i*tile_size + tile_size + border - 1;
			var _y2 = j*tile_size + tile_size + border - 1;

			var _mouse_col = point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x2, _y2);
			var _outline = true;
		
			if ( my_turn && state = state_choosing && _mouse_col ) {
				_outline = false;
				draw_set_color(c_red);
			
				selected_grid.x = i;
				selected_grid.y = j;
			}		
			
			var _entity = map[i][j];
			if (is_struct(_entity) && _entity.x == i && _entity.y == j ) {
				draw_sprite(spr_players, _entity.sprite, _x1, _y1);
			}
		
			draw_rectangle(_x1, _y1, _x2 + _mouse_col, _y2 + _mouse_col, _outline);
			draw_set_color(c_white)

		}
	}
}
