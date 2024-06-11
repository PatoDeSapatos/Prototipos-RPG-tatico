/// @description
if ( (room == rm_dungeon || room == rm_waiting_room) && global.server.dungeon_code != "" ) {
	global.server.send_websocket_message("LEAVE_DUNGEON", {invite: global.server.dungeon_code});
	global.server.send_chat_message("LEAVE", "left");
}

global.server.websocket_disconnect();