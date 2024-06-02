function Request(_reaction) constructor {
	id = -1;
	reaction = _reaction;
}

global.url = "http://localhost:8080";
global.user_token = "";
socket = network_create_socket(network_socket_ws);
user_logged = false;
username = "";
dungeon_code = "";

request_function = -1;
requests = [
	new Request(set_new_user)
];

function send_websocket_message(_type, _data) {
	var Buffer = buffer_create(1, buffer_grow ,1);
	
	var _message = ds_map_create();
	ds_map_add(_message, "messageType", _type);
	ds_map_add(_message, "token", global.user_token);
	ds_map_add(_message, "data", _data);

	buffer_write(Buffer , buffer_text  , json_encode(_message));
	network_send_raw(socket, Buffer, buffer_tell(Buffer), network_send_text);
	buffer_delete(Buffer);
	ds_map_destroy(_message);
}

websocket_connect = function () {
	network_connect_raw_async(socket, "localhost/ws", 8080);
}

websocket_disconnect = function () {
	network_destroy(socket);	
}

websocket_connect();