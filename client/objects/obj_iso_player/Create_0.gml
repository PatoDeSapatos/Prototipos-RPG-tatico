global.controls = {
	key_up: [ord("W"), vk_up],
	key_down: [ord("S"), vk_down],
	key_left: [ord("A"), vk_left],
	key_right: [ord("D"), vk_right]
}

function Input(_key_name) constructor {
	value = false;
	key_name = _key_name;
}

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

tile_size = obj_draw.tile_size
hspd = -1;
vspd = -1;
z = - tile_size / 2
spd = 5;

function collision() {
	var collides = false
	
	var htile = obj_draw.grid[# screenToTileX(x + hspd, y), screenToTileY(x + hspd, y)]
	if (!is_undefined(htile)) {
		if (htile.spr == 5) {
			//x -= x mod tile_size
			//if (sign(hspd) == 1) x += tile_size - 1
			hspd = 0
			collides = true
		}
	}
	x += hspd
	
	var vtile = obj_draw.grid[# screenToTileX(x, y + vspd), screenToTileY(x, y + vspd)]
	if (!is_undefined(vtile)) {
		if (vtile.spr == 5) {
			//y -= y mod tile_size
			//if (sign(vspd) == 1) y += tile_size - 1
			vspd = 0
			collides = true
		}
	}
	y += vspd
	
	return collides
}