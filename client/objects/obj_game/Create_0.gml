/// @description Insert description here
url = "http://localhost:8080";

socket = network_create_socket(network_socket_ws)
network_connect_raw_async(socket, "localhost/ws", 8080)

global.playerId = 0;
global.battleId = 0;
global.loading = false;

global.player_exists = -1;
global.battle_exists = -1;

setup_requests();
room_goto_next();