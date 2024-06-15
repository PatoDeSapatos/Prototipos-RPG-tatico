function Cell(_x, _y, _g, _prev, _solid) constructor {
	x = _x;
	y = _y;
	g = _g;
	h = 0;
	f = g + h;
	previous_cell = _prev;
	
	function calc_distance(_x, _y) {
		h = abs(x - _x) + abs(y - _y);
		f = g + h;
	}
}

function get_shortest_path(_grid, _x1, _y1, _x2, _y2) {
	var _start = new Cell(_x1, _y1, 0, -1,false);
	var _end = new Cell(_x2, _y2, 0, -1, false);
	var _grid_copy = [];
	
	if ( (!is_inside_grid(_grid, _x1, _y1) || !is_inside_grid(_grid, _x2, _y2)) || (_grid[_x2, _y2] == 1) ) {
		return [];	
	}
	
	for (var i = 0; i < array_length(_grid); ++i) {
	   for (var j = 0; j < array_length(_grid[i]); ++j) {
	       _grid_copy[j, i] = 0;
	   }
	}
	
	var offsets = [
		[0, -1], //top
		[0, 1], //bottom
		[1, 0], //right
		[-1, 0], //left
	];
	
	var _expanded = [];
	var _open = [_start];
	while( array_length(_open) > 0 ) {
		var _cell = array_shift(_open);
		array_push(_expanded, _cell);
		if (_cell.x == _end.x && _cell.y == _end.y) {
			var _path = [];
			var _current_cell = _cell;
			while ( _current_cell != _start ) {
				array_push(_path, [_current_cell.x, _current_cell.y]);
				_current_cell = _current_cell.previous_cell;
			}
			return array_reverse(_path);
		}

		for (var i = 0; i < 4; ++i) {
			var _next_cell_x = _cell.x + offsets[i, 0];
			var _next_cell_y = _cell.y + offsets[i, 1];
			
		    if ( is_inside_grid(_grid, _next_cell_x, _next_cell_y) ) {
				var _next_cell = _grid_copy[_next_cell_x, _next_cell_y];
				
				if (!is_struct(_next_cell) && _grid[_next_cell_x, _next_cell_y] != 1) {
					var _new_cell = new Cell(_next_cell_x, _next_cell_y, _cell.h + 1, _cell, _next_cell);
					_new_cell.calc_distance(_end.x, _end.y);
					
					_grid_copy[_next_cell_x, _next_cell_y] = _new_cell;
					array_push(_open, _new_cell);
				}
			}
		}
		array_sort(_open, function(_cell1, _cell2) {
			return round(_cell1.f) - round(_cell2.f);
		});
	}
	
}

function is_inside_grid(_grid, _x, _y) {
	if ( (_y < 0 || _y >= array_length(_grid)) || (_x < 0 || _x >= array_length(_grid[0])) ) {
		return false;
	}
	return true;
}