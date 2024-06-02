/// @description Insert description here
if (is_string(error_message)) {
	if ( setup ) {
		var _string_width = string_width(error_message);
		width = _string_width > 550 ? ( _string_width + border*2 ) : ( 550 );
			
		var _string_height = string_height_ext(error_message, string_sep, width - border*2);
		height = _string_height > 100 ? (_string_height + border*2) : ( 100 );
			
		current_y = -height;
		current_x = (room_width - width)/2;
		setup = false;
	}
	
	if ( state == 0 ) {
		progress += progress_rate;
		if ( progress >= 1 ) state = 1;
	} else if ( state == 1 ) {
		wait_progress += 1/60;
		if ( wait_progress >= wait_time ) state = 2;
	} else if ( state == 2 ) {
		progress -= progress_rate;
		if ( progress <= 0 ) instance_destroy();
	}
	progress = clamp(progress, 0, 1);
	current_y = (height * progress);
	
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_color(c_white);
	draw_set_alpha(.75);
	draw_rectangle(current_x, 0, current_x + width, current_y, false);
	draw_set_color(c_red);
	draw_set_alpha(1);
	draw_text(room_width/2, current_y - height/2, error_message);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
}
