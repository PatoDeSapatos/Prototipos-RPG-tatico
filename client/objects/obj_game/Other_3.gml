/// @description
if ( os_is_network_connected(global.socket) ) {
	send_websocket_message("SET_PLAYER_OFFLINE", {});
}