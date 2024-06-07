/// @description
global.server.send_websocket_message("DUNGEON_STATE", {invite: obj_server.dungeon_code});
entities = ds_map_create();
update_entities = function (_data) {
	var _entities = struct_get(_data, "entities");
	
	for (var i = 0; i < array_length(_entities); ++i) {
		if ( !is_struct(_entities[i]) ) {
			show_message(_entities[i]);
			continue;	
		}
		
		var _entity_id = struct_get(_entities[i], "id");
		
		if ( ds_map_exists(entities, _entity_id) ) {
			ds_map_find_value(entities, _entity_id).update_entity_values( struct_get(_entities[i], "data"), struct_get(_entities[i], "username") );
		} else {
			var _entity = instance_create_layer(room_width/2, room_height/2, "Instances", obj_player);
			_entity.player_username = struct_get(_entities[i], "username");
			_entity.entity_id = _entity_id;
			ds_map_set(entities, _entity_id, _entity);	
		}
	    
	}
}

//map = generate_dungeon()