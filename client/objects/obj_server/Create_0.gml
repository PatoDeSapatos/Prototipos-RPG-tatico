function Request(_reaction) constructor {
	id = -1;
	reaction = _reaction;
}
ip = "localhost";
port = "8081";
global.url = "http://" + ip + ":" + port;
global.user_token = "";
socket = -1
user_logged = false;
username = "";
admin_username = "";
dungeon_code = "";
level = 1
is_user_guest = false;
guest_password = "";
mapSeed = -1

request_function = -1;
requests = [
	new Request(create_guest_reaction)
];

function send_websocket_message(_type, _data) {
	var Buffer = buffer_create(1, buffer_grow ,1);
	
	var _message = ds_map_create();
	ds_map_add(_message, "messageType", _type);
	ds_map_add(_message, "data", _data);

	buffer_write(Buffer , buffer_text  , json_encode(_message));
	network_send_raw(socket, Buffer, buffer_tell(Buffer), network_send_text);
	buffer_delete(Buffer);
	ds_map_destroy(_message);
}

function send_chat_message(_type, _text) {
	if (_type == "CHAT" && string_trim_end(_text) == "") return;
	
	var _message = {};
	struct_set(_message, "invite", dungeon_code);
	struct_set(_message, "message", _text);
	struct_set(_message, "type", _type);
	send_websocket_message("SEND_CHAT_MESSAGE", _message);	
}

websocket_connect = function () {
	if (socket != -1) websocket_disconnect()
	socket = network_create_socket(network_socket_ws);
	network_connect_raw_async(socket, ip + "/ws/" + global.user_token, port);
}

websocket_disconnect = function () {
	if ( is_user_guest ) {
		var _url = global.url + "/user/guest/remove";
		var _header = ds_map_create();
	
		ds_map_add(_header, "Content-Type", "application/json");
		user_register = http_request(_url, "POST", _header, global.server.username);
		ds_map_destroy(_header);
	}
	network_destroy(socket);
}

set_url = function(_ip, _port) {
	ip = _ip;
	port = _port;
	
	global.url = "http://" + ip + ":" + port;
}

function login_guest() {
	global.loading = true;
	var _url = global.url + "/user/guest";
	var _header = ds_map_create();
	
	ds_map_add(_header, "Content-Type", "application/json");
	requests[0].id = http_request(_url, "POST", _header, "");
	ds_map_destroy(_header);
}

login_guest()