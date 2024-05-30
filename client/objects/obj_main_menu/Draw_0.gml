// Setting options selected
menu_get_option_selected();

switch (page) {
	case 0:
		if ( setup ) {
			width = room_width;
			height = room_height;
			offset = 10;
			
			var _menu_height = 0;
			for (var i = 0; i < array_length(options[page]); i++) {
			    var _string  = options[page, i];
				_menu_height += string_height(_string) + offset;
			}
			
			start_x = width/2;
			start_y = (height - _menu_height)/2;
			setup = false;
		}
		
		if ( input_forward ) {
			switch ( option_selected ) {
				case 0: case 1: case 2: case 3:
					menu_change_page( option_selected+1 );
					break;
				case 4:
					game_end();
					break;
			}
		}
		break;
	case 1:
		if ( input_forward ) {
			if ( option_selected == 0 ) {
				menu_change_page(6);
			} else if ( option_selected == 1 ) {
				menu_change_page(7);
			} else if ( option_selected == array_length(options[page])-1 ) {
				menu_change_page(0);
				return;
			}
		}
		break;
	case 3:
		if ( !global.server.user_logged ) {
			menu_change_page(5);
			return;
		}
	
		if ( input_forward ) {
			if ( option_selected ==  array_length(options[page])-1 ) {
				menu_change_page(0)
				return;
			}
		}
		break;
	case 5:
		draw_text_input_page(global.server.request_new_user);
		break;
	case 7:
		draw_text_input_page(place_holder);
		break;
}

if ( input_back && page > 0 ) {
	menu_change_page(0);
}

// Drawing Menu
var _current_y = start_y;
for (var i = 0; i < array_length(options[page]); i++) {
	var _string = options[page, i];
	var _color =  option_selected == i ? (c_yellow) : (c_white);
	draw_set_halign(fa_middle);
	draw_set_valign(fa_center);
	draw_set_color(_color);	

    draw_text(start_x, _current_y, _string);
	_current_y += string_height(_string) + offset;
	
	draw_set_color(c_white);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}

