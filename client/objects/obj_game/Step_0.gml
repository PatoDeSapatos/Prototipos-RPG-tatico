/// @description Insert description here
if ( keyboard_check_pressed(ord("R")) ) {
	send_websocket_message("SET_PLAYER_OFFLINE", {});
	game_restart();
}

if ( keyboard_check_pressed(ord("N")) ) {
	send_websocket_message("RESET", {"battleId": 0});
	send_websocket_message("SET_PLAYER_OFFLINE", {});
	game_restart();
}