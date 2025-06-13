_x = x
_y = y

function set_uid(_x, _y) {
	uid = string_concat(global.server.level, "|", _x, "|", _y)
}

function send_entity() {
    var _data = {
        invite: global.server.dungeon_code,
        entityId: uid,
        data: {
            x,
            y
        }
    }
    global.server.send_websocket_message("UPDATE_ENTITY", _data)
}

function update_entity_values(_new_values) {
    if (global.server.admin_username != global.server.username) {
        _x = struct_get(_new_values, "x")
        _y = struct_get(_new_values, "y")
    }
}