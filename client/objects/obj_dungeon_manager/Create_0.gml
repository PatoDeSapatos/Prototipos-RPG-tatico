/// @description
global.server.send_websocket_message("DUNGEON_STATE", {invite: obj_server.dungeon_code});
entities = ds_map_create();

global.camera.camera_w = 640;
global.camera.camera_h = 360;
global.res_scale = 1280/global.camera.camera_w;

update_entities = function (_data) {
	var _entities = struct_get(_data, "entities");
	
	for (var i = 0; i < array_length(_entities); ++i) {
		if ( !is_struct(_entities[i]) ) {
			show_message(_entities[i]);
			continue;	
		}
		
		var _entity_id = struct_get(_entities[i], "id");
		
		if ( ds_map_exists(entities, _entity_id) ) {
			if (is_struct(struct_get(_entities[i], "data"))) {
				ds_map_find_value(entities, _entity_id).update_entity_values( struct_get(_entities[i], "data"), struct_get(_entities[i], "username") );
			}
		} else {
			var _entity = instance_create_layer(room_width/2, room_height/2, "Instances", obj_player);
			var _username = struct_get(_entities[i], "username");
			
			_entity.player_username = _username;
			_entity.entity_id = _entity_id;
			ds_map_set(entities, _entity_id, _entity);	
			if ( global.server.username == _username ) {
				global.camera.follow = _entity;	
			}
		}
	    
	}
}

instance_create_layer(0, 0, "Instances", obj_draw);

roomsWidth = obj_draw.width / obj_draw.roomSize
roomsHeight = obj_draw.height / obj_draw.roomSize
roomsAmount = 40
salas = 1

nodeGrid = []
for (var i = 0; i < roomsHeight; i++) {
	nodeGrid[i] = []
	for (var j = 0; j < roomsWidth; j++) {
	    nodeGrid[i][j] = []
	}
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

map = generate_dungeon();