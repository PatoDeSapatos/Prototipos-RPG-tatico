global.loading = true;

switch( async_load[? "id"] ) {
	case username_exists:
		if ( async_load[? "status"] == 0 ) {
			var _username_exists = async_load[? "result"];
			if ( _username_exists ) {
				create_error_message("Username already exists.");
			} else {
				keyboard_string = "";
				menu_change_page(MAIN_MENU_PAGES.REGISTER_PASSWORD);
			}
		} else {
			create_error_message("Error while communicating with server.");
		}
		break;
	case user_register:
		if ( async_load[? "status"] == 0 ) {
			global.user_token = struct_get( json_parse( async_load[? "result"] ), "token" );
			global.server.username = username;
			menu_change_page(MAIN_MENU_PAGES.PRINCIPAL);
		} else {
			create_error_message("Username already taken.");
		}
		break;
	case user_login:
		if ( async_load[? "status"] == 0 ) {
			global.user_token = struct_get( json_parse( async_load[? "result"] ), "token" );
			global.server.username = username;
			menu_change_page(MAIN_MENU_PAGES.PRINCIPAL);
		} else {
			create_error_message("Username and password dont't match");
		}
		break;
}

global.loading = false;