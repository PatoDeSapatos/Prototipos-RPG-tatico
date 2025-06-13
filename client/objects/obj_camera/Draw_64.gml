/// @description
if ( transition != -1 ) {
	transition_end = script_execute(transition);
} else transition_end = -1;

// VFX
cinematic_bar_progress = lerp(cinematic_bar_progress, cinematic_bar, cinematic_bar_rate);

var _gui_width = display_get_gui_width();
var _gui_height = display_get_gui_height();
var _bar_height = cinematic_bar_progress*100/_gui_height;

draw_set_color(c_black);
draw_rectangle(0, 0, _gui_width, _bar_height, false);	
draw_rectangle(0, _gui_height, _gui_width, _gui_height - _bar_height, false);
draw_set_color(c_white)