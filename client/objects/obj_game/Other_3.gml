/// @description
if ( room == rm_dungeon && global.server.dungeon_code != "" ) {
	global.server.send_websocket_message("LEAVE_DUNGEON", {invite: global.server.dungeon_code});
}

global.server.websocket_disconnect();