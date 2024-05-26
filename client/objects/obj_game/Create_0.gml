/// @description Insert description here
url = "http://localhost:8080";

global.socket = network_create_socket(network_socket_ws)
network_connect_raw_async(global.socket, "localhost/ws", 8080)

global.playerId = -1;
global.battleId = -1;
global.loading = false; 

setup_requests();
room_goto_next();

