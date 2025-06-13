/// @desc updating entity in server

if (player_username != global.server.username) return;

var _new_entity_data = {
    x: round(x),
    y: round(y),
    sprites,
    sprite_index,
    image_index,
    facing_right,
    facing_up
}

var _temp = {}

struct_foreach(_new_entity_data, method({_temp, entity_data}, function(key, value) {
    if (value != struct_get(entity_data, key)) {
        struct_set(_temp, key, value)
        struct_set(entity_data, key, value)
    }
}))

if (struct_names_count(_temp) > 0) {
    var _data = {};
    
    struct_set(_data, "invite", global.server.dungeon_code);
    struct_set(_data, "entityId", entity_id);
    struct_set(_data, "data", _temp);
    
    global.server.send_websocket_message("UPDATE_ENTITY", _data);
    
    entity_data = {}
}

alarm[0] = 3
