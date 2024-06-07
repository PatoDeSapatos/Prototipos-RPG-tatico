/// @description
global.server.send_websocket_message("DUNGEON_STATE", {invite: obj_server.dungeon_code});
entities = ds_map_create();
update_entities = function (_entities) {
	for (var i = 0; i < array_length(_entities); ++i) {
		if ( !is_struct(_entities[i]) ) {
			show_message(_entities[i]);
			continue;	
		}
		
		var _entity_id = struct_get(_entities[i], "id");
		
		if ( ds_map_exists(entities, _entity_id) ) {
			ds_map_find_value(entities, _entity_id).update_entity_values( struct_get(_entities[i], "data") );
		} else {
			var _entity = instance_create_layer(room_width/2, room_height/2, "Instances", obj_player);
			_entity.player_username = struct_get(_entities[i], "username");
			_entity.entity_id = _entity_id;
			ds_map_set(entities, _entity_id, _entity);	
		}
	    
	}
}

//tamanho do room tem que ser divisível por tile_size * roomSize * scale
roomSize = 10
roomsWidth = obj_draw.width / roomSize
roomsHeight = obj_draw.height / roomSize
roomsAmount = 40
salas = 1

nodeGrid = []
for (var i = 0; i < roomsHeight; i++) {
	nodeGrid[i] = []
}

nodes = []
emptyNode = -1

toCollapse = []

offsets = [
	new Point(0, -1), //top
	new Point(0, 1), //bottom
	new Point(1, 0), //right
	new Point(-1, 0), //left
]

offsetLetter = [
	"U",
	"D",
	"R",
	"L"
]

map = generate_dungeon()