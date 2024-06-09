switch(async_load[? "type"]){
	case network_type_non_blocking_connect:
		if (global.user_token == "") {
			global.loading = true;
			var _url = global.url + "/user/guest";
			var _header = ds_map_create();
	
			ds_map_add(_header, "Content-Type", "application/json");
			requests[0].id = http_request(_url, "POST", _header, "");
			ds_map_destroy(_header);
		}
		break;
	case network_type_data:
		var buffer_raw = async_load[? "buffer"];
		var buffer_processed = buffer_read(buffer_raw , buffer_text);
		var _message_type;
		var _data;
		try {
			var realData = json_parse(buffer_processed);
			_message_type = struct_get(realData, "messageType");
			_data = struct_get(realData, "data");
		} catch(_error) {
			show_debug_message("Failed server response.");
			show_debug_message(_error);
			return;
		}
		
		switch(_message_type) {
			case "WAITING":
				if (struct_get(_data, "started") == true && room != rm_dungeon) {
					dungeon_code = obj_waiting_room_menu.dungeon_code;
					room_goto(rm_dungeon);
				} else if (room != rm_waiting_room) {
					room_goto(rm_waiting_room);
					var _data = {};
					struct_set(_data, "invite", dungeon_code);
					send_websocket_message("GET_WAITING_STATE", _data);
				}
				
				if ( instance_exists(obj_waiting_room_menu) ) {
					var _players = struct_get(_data, "players");
					var _dungeon_code = struct_get(_data, "invite");
					var _adm = struct_get(_data, "adm")
					var _is_dungeon_public = struct_get(_data, "isPublic");
					
					obj_waiting_room_menu.update_players(_players);
					obj_waiting_room_menu.dungeon_code = _dungeon_code;
					obj_waiting_room_menu.dungeon_privacy = _is_dungeon_public ? ("Public") : ("Private");
					obj_waiting_room_menu.waiting_server = false;
					obj_waiting_room_menu.admin_username = _adm;
				}
				break;
			case "DUNGEON_STATE":
				show_message(_data);
				if ( room != rm_dungeon ) {
					room_goto(rm_dungeon);
				} else if ( instance_exists(obj_dungeon_manager) ) {
					obj_dungeon_manager.update_entities(_data);
				}
				break;
		}
		break;
	case network_type_disconnect:
		global.server.websocket_connect();
		break;
} 