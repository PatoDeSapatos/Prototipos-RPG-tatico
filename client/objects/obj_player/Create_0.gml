/// @description
function Input(_key_name) constructor {
	value = false;
	key_name = _key_name;
}

idle_frames = 4;
current_image = 0;
animation_spd = 5;

sprites = new SpriteSet(0, 0, 0, 0, 0);
head_sprites = [spr_hair, spr_head_acessories, spr_hats];
facing_right = 1;
facing_up = false;

entity_data = {}

state = -1;
hspd = -1;
vspd = -1;
_x = x;
_y = y;
spd = 3;
player_username = "";
entity_id = -1;
scale = 1;

tile_size = obj_dungeon_manager.tile_size
z = - tile_size / 2

input_magnitude = -1;
input_direction = -1;

gamepad_id = -1;

inputs = {
	input_up: new Input("key_up"),
	input_down: new Input("key_down"),
	input_left: new Input("key_left"),
	input_right: new Input("key_right")
}

up = -1;
down = -1;
left = -1;
right = -1;

state_player_free = function () {
	var _initial_sprite = sprite_index;
	var _angle = 0;
	
	if ( (input_direction > 0 && input_direction < 90) || (input_direction > 180 && input_direction < 270 ) ) {
		_angle = spd > 0 ? (-13) : (13)
	} else {
		_angle = spd > 0 ? (13) : (-13)
	}
	
	hspd = lengthdir_x(spd * input_magnitude, input_direction + _angle);
	vspd = lengthdir_y(spd * input_magnitude, input_direction + _angle);
	
	if ( hspd < 0 ) {
		facing_right = -1;
	} else if ( hspd > 0 ) {
		facing_right = 1;	
	}
	
	if ( vspd < 0 ) {
		facing_up = true;
	} else if ( vspd > 0 ) {
		facing_up = false;	
	}
	
	animate();
	collision();
	
	x += hspd;
	y += vspd;
}

update_entity_values = function(_new_values, _username, _level) {
	if (_username != global.server.username) {
		_x = struct_get(_new_values, "x");
		_y = struct_get(_new_values, "y");
		sprites = struct_get(_new_values, "sprites");
		sprite_index = struct_get(_new_values, "sprite_index");
		image_index = struct_get(_new_values, "image_index");
		facing_right = struct_get(_new_values, "facing_right");
		facing_up = struct_get(_new_values, "facing_up");
		level = _level
	} else {
		if (_level != global.server.level) {
			global.server.level = _level
			room_restart()
		}
	}
}

state = state_player_free;
alarm[0] = 3