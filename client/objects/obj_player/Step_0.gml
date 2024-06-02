/// @description Getting player inputs
if ( player_username == global.server.username ) {
	struct_foreach(inputs, function (_key, _value) { 
		var _key_name = struct_get( _value, "key_name" );
		var _keys = struct_get(global.controls, _key_name);
		var _active = false;

		for (var i = 0; i < array_length(_keys); ++i) {
		    _active = _active || keyboard_check(_keys[i]);
		}
	
		struct_set(struct_get(inputs, _key), "value", _active);
	});

	up = inputs.input_up.value;
	down = inputs.input_down.value;
	left = inputs.input_left.value;
	right = inputs.input_right.value;

	input_magnitude = (down - up != 0) || (right - left != 0);
	input_direction = point_direction(0, 0, right - left, down - up);

	state();
	
	var _data = {};
	var _entity_data = {
		x: _x,
		y: _y
	};
	
	struct_set(_data, "invite", global.server.dungeon_code);
	struct_set(_data, "entityId", entity_id);
	struct_set(_data, "data", _entity_data);
	global.server.send_websocket_message("UPDATE_ENTITY", _data);
}
