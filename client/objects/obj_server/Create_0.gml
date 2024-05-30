function Request(_reaction) constructor {
	id = -1;
	reaction = _reaction;
}

url = "http://localhost:8080";
socket = network_create_socket(network_socket_ws);
user_logged = false;
user_username = "";

request_function = -1;
requests = [
	new Request(set_new_user)
];

request_new_user = function (_username) {
	
}