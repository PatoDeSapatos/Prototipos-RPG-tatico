function Color(_r, _g, _b, _a) constructor {
	r = _r;
	g = _g;
	b = _b;
	a = _a;
}

function load_map_images() {
	if (!directory_exists(working_directory + "\\dungeon_rooms")) {
		return;
	}
	
	var _rooms = [];
	var _room_name = file_find_first(working_directory + "\\dungeon_rooms\\source\\*.png", 0);
	
	while(_room_name != "") {
		array_push(_rooms, _room_name);
		_room_name = file_find_next();
	}
	
	file_find_close();
	rotate_map_images(_rooms);
}

function rotate_map_images(_rooms) {
	if ( !is_array(_rooms) || array_length(_rooms) <= 0 ) {
		return;
	}

	for (var i = 0; i < array_length(_rooms); ++i) {
		var _file_name = working_directory + "dungeon_rooms\\source\\" + _rooms[i];
		if ( file_exists( _file_name ) ) {
			generate_rotated_image(_rooms[i]);
		}
	}
}

function generate_rotated_image(_image_name) {
	var _name_splited = string_split(_image_name, "_");
	var _room_identifier = _name_splited[0] + "_" + _name_splited[1] + "_";
	var _room_directions = _name_splited[2];
	
	var _current_name = working_directory + "dungeon_rooms\\source\\" + _image_name;
	var _new_file_name = working_directory + "dungeon_rooms\\generated\\" + _image_name; 
	var _current_direction = _room_directions;
	
	if ( !file_exists(_new_file_name) ) {
		var _sprite = sprite_add(_current_name, 1, 0, 0, 0, 0);
		var _width = sprite_get_width(_sprite);
		var _height = sprite_get_height(_sprite);
		
		// Setting Surface
		var _surf = surface_create(_width, _height);
		surface_set_target(_surf);
		draw_clear_alpha(c_black, 0);
		draw_sprite(_sprite, 0, 0, 0);
		surface_reset_target();
		sprite_delete(_sprite);
		surface_save(_surf, _new_file_name);
		surface_free(_surf);
	}
	
	var _cicles = is_room_ud(_room_directions) ? (1) : (3);
	
	for (var i = 0; i < _cicles; ++i) {
	    var _rotated_name = generate_rotated_name(_current_direction);
		_new_file_name = working_directory + "dungeon_rooms\\generated\\" + _room_identifier + _rotated_name + ".png";
		
		if ( _rotated_name == "" || file_exists(_new_file_name) ) {
			continue;
		}
		
		// Setting sprite
		var _sprite = sprite_add(_current_name, 1, 0, 0, 0, 0);
		var _width = sprite_get_width(_sprite);
		var _height = sprite_get_height(_sprite);
				
		_current_direction = _rotated_name;
		_current_name = working_directory + "dungeon_rooms\\generated\\" + _room_identifier + _current_direction + ".png";
		
		// Setting Surface
		var _surf = surface_create(_width, _height);
		surface_set_target(_surf);
		draw_clear_alpha(c_black, 0);
		draw_sprite(_sprite, 0, 0, 0);
		surface_reset_target();
		sprite_delete(_sprite);
		
		// Setting Buffer
		var _buffer = buffer_create(4 * _width * _height, buffer_fixed, 1);
		buffer_get_surface(_buffer, _surf, 0);
		surface_free(_surf);
		
		// Reading Buffer
		var _image_pixels = [];
		
		for (var j = 0; j < _height; ++j) {
		    for (var k = 0; k < _width; ++k) {
				_image_pixels[j, k] = [];
			}
		}
		
		for (var _y = 0; _y < _height; ++_y) {
		    for (var _x = 0; _x < _width; ++_x) {
			    buffer_seek(_buffer, buffer_seek_start, 4 * (_x + _y * _width));

				var _r = buffer_read(_buffer, buffer_u8);
				var _g = buffer_read(_buffer, buffer_u8);
				var _b = buffer_read(_buffer, buffer_u8);
				var _a = buffer_read(_buffer, buffer_u8);
			
				var _color = new Color(_r, _g, _b, _a);
				_image_pixels[_x, _y] = _color;
			}
		}
		buffer_delete(_buffer);
		
		// Rotate Array
		for (var j = 0; j < floor(array_length(_image_pixels)/2); ++j) {
			var _l = array_length(_image_pixels) - 1;
		    
			for (var k = 0; k < array_length(_image_pixels) - (2*j) - 1; ++k) {
				var _temp = _image_pixels[j, j+k];
				
			    _image_pixels[j, j+k] = _image_pixels[_l-j-k, j];
				_image_pixels[_l-j-k, j] = _image_pixels[_l-j, _l-k-j];
				_image_pixels[_l-j, _l-k-j] = _image_pixels[j+k, _l-j];
				_image_pixels[j+k, _l-j] = _temp;
			}
		}
		
		// Creating Rotated Image
		var _buffer_rotated = buffer_create(4 * _width * _height, buffer_fixed, 1);
		for (var _y = 0; _y < _height; ++_y) {
		    for (var _x = 0; _x < _width; ++_x) {
			    buffer_seek(_buffer_rotated, buffer_seek_start, 4 * ( _x + _y * _width));
				
				buffer_write(_buffer_rotated, buffer_u8, _image_pixels[_x, _y].r);	
				buffer_write(_buffer_rotated, buffer_u8, _image_pixels[_x, _y].g);	
				buffer_write(_buffer_rotated, buffer_u8, _image_pixels[_x, _y].b);	
				buffer_write(_buffer_rotated, buffer_u8, _image_pixels[_x, _y].a);	
			}
		}
		
		var _surf = surface_create(_width, _height);
		buffer_set_surface(_buffer_rotated, _surf, 0);
		surface_save(_surf, _new_file_name);
		
		surface_free(_surf);
		buffer_delete(_buffer_rotated);
	}
	
}

function generate_rotated_name(_image_name) {
	_image_name = string_upper( array_get( string_split(_image_name, "."), 0 ) );
	if ( string_length(_image_name) >= 4 ) return "";

	var _rotated_name = "";
	
	for (var i = 1; i <= string_length(_image_name); ++i) {
	    var _char = string_char_at(_image_name, i);
		
		switch(_char) {
			case "U":
				_rotated_name += "L";
				break;
			case "R":
				_rotated_name += "U";
				break;
			case "D":
				_rotated_name += "R";
				break;
			case "L":
				_rotated_name += "D";
				break;
		}
	}
	
	return _rotated_name;
}

function is_room_ud(_directions) {
	_directions = string_upper( array_get( string_split(_directions, "."), 0 ) );
	
	if ( string_length(_directions) == 2 ) {
		if ( string_char_at(_directions, 1) == "U" && string_char_at(_directions, 2) == "D" ) {
			return true;	
		}
	}
	
	return false;
}