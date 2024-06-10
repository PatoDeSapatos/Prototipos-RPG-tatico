function cast_dungeon() {
	var surface = surface_create(obj_draw.width, obj_draw.height)
	surface_set_target(surface);
	draw_clear_alpha(c_black, 0);
	var sprites = []

	for (var _x = 0; _x < array_length(nodeGrid); ++_x) {
	    for (var _y = 0; _y < array_length(nodeGrid[_x]); ++_y) {
		    
			var node = nodeGrid[_x][_y]
			if (node.fileName == "") continue
			var sprite = sprite_add(working_directory + "\\dungeon_rooms\\generated\\" + node.fileName, 1, 0, 0, 0, 0)
			draw_sprite(sprite, 0, _y * obj_draw.roomSize, _x * obj_draw.roomSize)
			array_push(sprites, sprite)
		}
	}

	surface_reset_target();
	
	for (var i = 0; i < array_length(sprites); ++i) {
	    sprite_delete(sprites[i])
	}
	
	var _buffer = buffer_create(4 * surface_get_width(surface) * surface_get_height(surface), buffer_fixed, 1);
	buffer_get_surface(_buffer, surface, 0);
	
	for (var _y = 0; _y < surface_get_height(surface); ++_y) {
		for (var _x = 0; _x < surface_get_width(surface); ++_x) {
			buffer_seek(_buffer, buffer_seek_start, 4 * (_x + _y * surface_get_width(surface)));

			var _r = buffer_read(_buffer, buffer_u8);
			var _g = buffer_read(_buffer, buffer_u8);
			var _b = buffer_read(_buffer, buffer_u8);
			var _a = buffer_read(_buffer, buffer_u8);
			
			var _color = make_color_rgb(_r, _g, _b);
			
			switch (_color) {
				//Wall
				case 4194559:
					obj_draw.grid[# _x, _y] = new Tile(5, 0)
					break
				//Floor
				case 2170681:
					obj_draw.grid[# _x, _y] = new Tile(1, 0)
					break
			}
		}
	}
	surface_save(surface, working_directory + "mapa.png")
	surface_free(surface);
	buffer_delete(_buffer);
}

function Tile(_spr, _z) constructor {
	spr = _spr
	z = _z
}