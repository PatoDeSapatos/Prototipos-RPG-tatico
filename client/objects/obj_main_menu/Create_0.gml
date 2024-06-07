// Menu parameters
setup = true;
page = 0;
option_selected = 0;

width = -1;
height = -1;
start_x = 0;
start_y = 0;
offset = 10;
reading_string = "";
max_string_length = 0;

input_up = -1;
input_down = -1;
input_forward = -1;
input_back = -1;

// Requests
username_exists = -1;
user_register = -1;
user_login = -1;

username = "";
password = "";

// Options per page
function setup_options( _page ) {
	switch (_page) {
		case MAIN_MENU_PAGES.PRINCIPAL:
			options[MAIN_MENU_PAGES.PRINCIPAL] = ["Enter in Dungeon", "Create Dungeon", global.server.user_logged && !global.server.is_user_guest ? ("Account") : ("Register/Login"), "Options", "Exit"];
			break;
		case MAIN_MENU_PAGES.ENTER_DUNGEON:
			options[MAIN_MENU_PAGES.ENTER_DUNGEON] = ["Public Dungeons", "Enter With Code", "Back"];
			break;
		case MAIN_MENU_PAGES.CREATE_DUNGEON:
			options[MAIN_MENU_PAGES.CREATE_DUNGEON] = ["Carregando..."];
			break;
		case MAIN_MENU_PAGES.ACCOUNT: // Account
			if ( global.server.user_logged && !global.server.is_user_guest ) {
				options[MAIN_MENU_PAGES.ACCOUNT, 0] = global.server.username;
				options[MAIN_MENU_PAGES.ACCOUNT, 1] = "Logout";
				options[MAIN_MENU_PAGES.ACCOUNT, 2] = "Back"
			} else {
				options[MAIN_MENU_PAGES.ACCOUNT, 0] = "";
			}
			break;
		case MAIN_MENU_PAGES.OPTIONS:
			options[MAIN_MENU_PAGES.OPTIONS] = ["Options"];
			break;
		case MAIN_MENU_PAGES.REGISTER_USERNAME: // Register - username
			options[MAIN_MENU_PAGES.REGISTER_USERNAME] = ["Username:", "", "Send", "Cancel"];
			break;
		case MAIN_MENU_PAGES.REGISTER_PASSWORD: // Register - password
			options[MAIN_MENU_PAGES.REGISTER_PASSWORD] = ["Password:", "", "Send", "Cancel"];
			break;
		case MAIN_MENU_PAGES.LOGIN_USERNAME: // Login - username
			options[MAIN_MENU_PAGES.LOGIN_USERNAME] = ["Username:", "", "Send", "Cancel"];
			break;
		case MAIN_MENU_PAGES.LOGIN_PASSWORD: // Login - password
			options[MAIN_MENU_PAGES.LOGIN_PASSWORD] = ["Password:", "", "Send", "Cancel"];
			break;
		case MAIN_MENU_PAGES.PUBLIC_DUNGEON:
			options[MAIN_MENU_PAGES.PUBLIC_DUNGEON] = ["Public Dungeons"];
			break;
		case MAIN_MENU_PAGES.PRIVATE_DUNGEON: // Enter Private Dungeon
			options[MAIN_MENU_PAGES.PRIVATE_DUNGEON] = ["Dungeon Code:", "", "Enter", "Cancel"];
			break;
		case MAIN_MENU_PAGES.REGISTER_LOGIN:
			options[MAIN_MENU_PAGES.REGISTER_LOGIN] = ["Register", "Login"];
			break;
	}
}
setup_options(0);

function menu_change_page( _page ) {
	option_selected = 0;
	page = _page;
	setup = true;
	setup_options(_page);
}

register_username_callback = function(_username) {
	if ( _username != "" ) {
		global.loading = true;
		var _url = string_concat(global.url,"/user/username/", string_trim(_username));
		username = _username;
		username_exists = http_get(_url);
	}
}

register_password_callback = function (_password) {
	global.loading = true;
	var _url = string_concat(global.url,"/user/register");
	var _header = ds_map_create();
	var _body = ds_map_create();
	ds_map_add(_body, "username", username);
	ds_map_add(_body, "password", _password);
	
	ds_map_add(_header, "Content-Type", "application/json");
	user_register = http_request(_url, "POST", _header, json_encode(_body));
	ds_map_destroy(_header);
	ds_map_destroy(_body);
}

login_username_callback = function (_username) {
	if ( _username != "" ) {
		username = _username;
		keyboard_string = "";
		menu_change_page(MAIN_MENU_PAGES.LOGIN_PASSWORD);	
	}
}

login_password_callback = function (_password) {
	global.loading = true;
	var _url = string_concat(global.url,"/user/login");
	var _header = ds_map_create();
	var _body = ds_map_create();
	ds_map_add(_body, "username", username);
	ds_map_add(_body, "password", _password);
	
	ds_map_add(_header, "Content-Type", "application/json");
	user_login = http_request(_url, "POST", _header, json_encode(_body));
	ds_map_destroy(_header);
	ds_map_destroy(_body);
	
	menu_change_page(MAIN_MENU_PAGES.PRINCIPAL);
}

enter_dungeon_with_code_callback = function (_code) {
	var _data = {};
	struct_set(_data, "invite", _code);
	global.server.dungeon_code = _code;
	global.server.send_websocket_message("JOIN_DUNGEON", _data);	
}