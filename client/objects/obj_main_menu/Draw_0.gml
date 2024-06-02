// Setting options selected
if (!global.loading) menu_get_option_selected();

switch (page) {
	case MAIN_MENU_PAGES.PRINCIPAL:
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
				case 0: case 1: case 3:
					menu_change_page( option_selected+1 );
					break;
				case 2:
					menu_change_page(MAIN_MENU_PAGES.REGISTER_LOGIN);
					break;
				case 4:
					game_end();
					break;
			}
		}
		break;
	case MAIN_MENU_PAGES.CREATE_DUNGEON:
		room_goto(rm_waiting_room);
		global.server.send_websocket_message("CREATE_DUNGEON", {});
		break;
	
	case MAIN_MENU_PAGES.ENTER_DUNGEON:
		if ( input_forward ) {
			if ( option_selected == 0 ) {
				menu_change_page(MAIN_MENU_PAGES.PUBLIC_DUNGEON);
			} else if ( option_selected == 1 ) {
				menu_change_page(MAIN_MENU_PAGES.PRIVATE_DUNGEON);
			} else if ( option_selected == array_length(options[page])-1 ) {
				menu_change_page(MAIN_MENU_PAGES.PRINCIPAL);
				return;
			}
		}
		break;
	case MAIN_MENU_PAGES.ACCOUNT:
		if ( !global.server.user_logged ) {
			menu_change_page(MAIN_MENU_PAGES.REGISTER_USERNAME);
			return;
		}
	
		if ( input_forward ) {
			if ( option_selected == array_length(options[page])-1 ) {
				menu_change_page(MAIN_MENU_PAGES.PRINCIPAL)
				return;
			} else if (option_selected == 1) { // Logout
				global.user_token = "";
				global.server.user_logged = false;
				global.server.user_username = "";
				menu_change_page(MAIN_MENU_PAGES.PRINCIPAL);
			}
		}
		break;
	case MAIN_MENU_PAGES.REGISTER_USERNAME:
		draw_text_input_page(register_username_callback);
		break;
	case MAIN_MENU_PAGES.REGISTER_PASSWORD:
		draw_text_input_page(register_password_callback);
		break;
	case MAIN_MENU_PAGES.LOGIN_USERNAME:
		draw_text_input_page(login_username_callback);
		break;
	case MAIN_MENU_PAGES.LOGIN_PASSWORD:
		draw_text_input_page(login_password_callback);
		break;
	case MAIN_MENU_PAGES.REGISTER_LOGIN:
		if ( input_forward ) {
			if ( option_selected == 0 )	{
				menu_change_page(MAIN_MENU_PAGES.REGISTER_USERNAME);	
			} else {
				menu_change_page(MAIN_MENU_PAGES.LOGIN_USERNAME);			
			}
		}
		break;
	case MAIN_MENU_PAGES.PRIVATE_DUNGEON:
		draw_text_input_page(enter_dungeon_with_code_callback);
		break;
		
}

if ( !global.loading && input_back && page > 0 ) {
	menu_change_page(MAIN_MENU_PAGES.PRINCIPAL);
}

// Drawing Menu
var _current_y = start_y;
for (var i = 0; i < array_length(options[page]); i++) {
	var _string = options[page, i];
	var _color = (option_selected == i && !global.loading) ? (c_yellow) : (c_white);
	draw_set_halign(fa_middle);
	draw_set_valign(fa_center);
	draw_set_color(_color);	

    draw_text(start_x, _current_y, _string);
	_current_y += string_height(_string) + offset;
	
	draw_set_color(c_white);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}

