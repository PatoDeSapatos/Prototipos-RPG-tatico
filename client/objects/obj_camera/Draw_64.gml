/// @description
if ( transition != -1 ) {
	transition_end = script_execute(transition);
} else transition_end = -1;


// VFX
if ( cinematic_bar ) {
	cinematic_bar_progress = lerp(cinematic_bar_progress, 1, cinematic_bar_rate);

	var _gui_width = display_get_gui_width();
	var _gui_height = display_get_gui_height();
	var _bar_height = _gui_height / 10;

	draw_set_color(c_black);
	draw_rectangle(0, 0, _gui_width, _bar_height * cinematic_bar_progress, false);	
	draw_rectangle(0, _gui_height, _gui_width, _gui_height - (_bar_height * cinematic_bar_progress), false);	
} else if ( cinematic_bar_progress > 0 ) {
	var _gui_width = display_get_gui_width();
	var _gui_height = display_get_gui_height();
	var _bar_height = _gui_height / 10;

	draw_set_color(c_black);
	draw_rectangle(0, 0, _gui_width, _bar_height * cinematic_bar_progress, false);	
	draw_rectangle(0, _gui_height, _gui_width, _gui_height - (_bar_height * cinematic_bar_progress), false);	
	
	cinematic_bar_progress -= cinematic_bar_rate;
}

cinematic_bar_progress = clamp( cinematic_bar_progress, 0, 1 );