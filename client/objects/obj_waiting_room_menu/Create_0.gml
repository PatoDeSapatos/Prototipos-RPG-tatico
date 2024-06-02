/// @description
change_privacy_callback = function() {
	var _data = {};
	struct_set(_data, "invite", dungeon_code);
	global.server.send_websocket_message("CHANGE_DUNGEON_PRIVACY", _data);
}

ready_button_callback = function() {
	var _data = {};
	struct_set(_data, "invite", dungeon_code);
	global.server.send_websocket_message("SET_PLAYER_READY", _data);
}

exit_button_callback = function() {
	var _data = {};
	struct_set(_data, "invite", dungeon_code);
	global.server.send_websocket_message("LEAVE_DUNGEON", _data);	
	room_goto(rm_main_menu);
}

function WaitingPlayer(_username, _ready) constructor {
	username = _username;
	ready = _ready;
}

setup = true;
waiting_server = true;
admin_username = -1;
menu_depth = depth;
alarm[0] = 20*60;

// Menu
width = room_width;
height = room_height;
border = 50;
menu_border = 10;

// Players Menu
player_menu_surface = -1;
player_menu_width = width/2 - border;
player_menu_height = height - border*2;
player_menu_card_height = 0;
player_card_width = player_menu_width - menu_border*2;
player_card_height = player_menu_height/7;
player_menu_y = 0;
max_players = 10;
waiting_players = [];
players_ready = false;

// Dungeon Info
dungeon_info_width = width/2 - border*2;
dungeon_info_height = height/2.5;
dungeon_code = "XXXXX";
dungeon_privacy = "Public";

code_box_height = (dungeon_info_height - menu_border)/3;
code_box_width = dungeon_info_width - menu_border*2;

// Buttons
buttons_width = dungeon_info_width;
buttons_height = dungeon_info_height/3.5;

// Change Privacy
var _x = width - dungeon_info_width - border;
var _y = (height - dungeon_info_height - buttons_height)/2

change_privacy_width = dungeon_info_width - border*2;
change_privacy_height = 50;
change_privacy_x = _x + border + change_privacy_width/2;
change_privacy_y = _y + dungeon_info_height - menu_border - change_privacy_height/2;

// Ready Dungeon
_y += dungeon_info_height + border;
enter_dungeon_width = buttons_width/2 - menu_border*1.5;
enter_dungeon_height = buttons_height - menu_border*2;

enter_dungeon_button = create_menu_button(
	_x + menu_border + enter_dungeon_width/2,
	_y + menu_border + enter_dungeon_height/2,
	enter_dungeon_width,
	enter_dungeon_height,
	"Start Dungeon",
	c_red,
	c_gray,
	c_white,
	c_white,
	ready_button_callback
);

// Exit
_x += enter_dungeon_width + menu_border;

create_menu_button(
	_x + menu_border + enter_dungeon_width/2,
	_y + menu_border + enter_dungeon_height/2,
	enter_dungeon_width,
	enter_dungeon_height,
	"Exit",
	c_red,
	c_grey,
	c_white,
	c_white,
	exit_button_callback
);

update_players = function(_players) {
	var _ready_players = 0;
	for (var i = 0; i < array_length(_players); ++i) {
		var _username = struct_get(_players[i], "username");
		var _ready = struct_get(_players[i], "ready");
		
		waiting_players[i] = new WaitingPlayer(_username, _ready);
		if ( _ready == true ) _ready_players++;
	}
	
	players_ready = _ready_players >= array_length(_players)-1;
}
