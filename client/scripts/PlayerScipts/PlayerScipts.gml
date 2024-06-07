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

function animate() {
	var _max_frames = idle_frames;
	var _init_frame = (facing_up) * _max_frames;
	var _final_frame = _init_frame + _max_frames;
	
	current_image += animation_spd / 60;
	if ( current_image >= _final_frame || current_image < _init_frame ) {
		current_image = _init_frame;	
	}

	image_index = current_image;
}