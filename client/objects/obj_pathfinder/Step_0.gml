/// @description
if (selected_cell != -1) {
	if (mouse_check_button_pressed(mb_left)) {
		grid[ selected_cell[0], selected_cell[1] ] = !grid[ selected_cell[0], selected_cell[1] ];
	}
	
	if (mouse_check_button_pressed(mb_right)) {
		start_cell = [selected_cell[0], selected_cell[1]];
		alarm[0] = spd;
	}
	
	path = get_shortest_path(grid, start_cell[0], start_cell[1], selected_cell[0], selected_cell[1]);
	show_debug_message(path);
}
