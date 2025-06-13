/// @description
if (global.loading_screen) {
	draw_set_color(c_black);
	
	draw_rectangle(
		0,
		0,
		display_get_gui_width(),
		display_get_gui_height(),
		false
	);
	draw_text_color(20, display_get_gui_height() - 20, "Loading", c_white, c_white, c_white, c_white, 1);
	
	draw_set_color(c_white);	
}