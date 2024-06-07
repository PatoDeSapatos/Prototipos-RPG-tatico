/// @description
function Input(_key_name) constructor {
	value = false;
	key_name = _key_name;
}

function Sprite(_sprite, _image) constructor {
	sprite = _sprite;
	image = _image;
}

idle_frames = 4;
current_image = 0;
animation_spd = 5;

sprites = [
	new Sprite(spr_hair, 0),
	new Sprite(spr_head_acessories, 0),
	new Sprite(spr_hand_acessories, 0),
	new Sprite(spr_hats, 0),
];
head_sprites = [spr_hair, spr_head_acessories, spr_hats];
facing_right = 1;
facing_up = false;
clothing = 0;

state = -1;
hspd = -1;
vspd = -1;
_x = x;
_y = y;
spd = 3;
player_username = "";
entity_id = -1;
scale = 3;

tile_size = obj_draw.tile_size
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
	
	hspd = lengthdir_x(spd * input_magnitude, input_direction);
	vspd = lengthdir_y(spd * input_magnitude, input_direction);
	
	if ( hspd < 0 ) {
		facing_right = -1;
	} else if ( hspd > 0 ) {
		facing_right = 1;	
	}
	
	facing_up = false;
	if ( vspd < 0 ) {
		facing_up = true;
	}
	
	animate();
	collision();
	
	x += hspd;
	y += vspd;
}

update_entity_values = function(_new_values, _username) {
	if (_username != global.server.username) {
		x = struct_get(_new_values, "x");
		y = struct_get(_new_values, "y");
		sprites = struct_get(_new_values, "sprites");
		sprite_index = struct_get(_new_values, "sprite_index");
		image_index = struct_get(_new_values, "image_index");
		facing_right = struct_get(_new_values, "facing_right");
		facing_up = struct_get(_new_values, "facing_up");
	}
	
}

state = state_player_free;