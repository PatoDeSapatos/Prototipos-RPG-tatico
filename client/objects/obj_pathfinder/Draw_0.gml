/// @description
var _start_x = (room_width - draw_size)/2;
var _start_y = (room_height - draw_size)/2;
selected_cell = -1;

for (var i = 0; i < grid_size; ++i) {
    for (var j = 0; j < grid_size; ++j) {
		var _x1 = _start_x + 1 + cell_size*j;
		var _y1 = _start_y + 1 + cell_size*i;
		var _x2 = _start_x - 1 + cell_size*j + cell_size;
		var _y2 = _start_y - 1 + cell_size*i + cell_size;
		var _outline = !(selected_cell != -1 && selected_cell[0] == i && selected_cell[1] == j);
		var _in_path = false;
		
		for (var k = 0; k < array_length(path); ++k) {
		    if ( path[k, 0] == i && path[k, 1] == j) {
				_in_path = true;
				break;
			}
		}
		
		if ( point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x2 ,_y2) ) {
			selected_cell = [i, j];
			draw_set_color(c_red);
		}
		
		if ( grid[i, j] ) {
			_outline = false;
			draw_set_color(c_white);
		}
		
		if (start_cell[0] == i && start_cell[1] == j) {
			_outline = false;
			draw_set_color(c_green);	
		}
		
		if (_in_path) {
			_outline = false;
			draw_set_color(c_yellow);
		}
		
	    draw_rectangle(
			_x1,
			_y1,
			_x2,
			_y2,
			_outline
		);	
		draw_set_color(c_white);
	}
}
