function draw_unit_desc(_unit) {
	if (!instance_exists(_unit)) return;
	
	var _gui_scale = display_get_gui_width()/RES_W*obj_battle_manager.scale;
	
	var _gui_w = display_get_gui_width();
	var _gui_h = display_get_gui_height();
	
	var _w = _gui_w/2.5;
	var _h = _gui_h;
	var _border = _w div 4;
	var _padding = 25;
	
	var _x = _gui_w - _w - _border;
	var _y = 0;
	
	var _fnt = draw_get_font();
	
	_unit.in_target = true;
	
	camera_set_x_buffer((_w + _border)/(2*_gui_scale), .2);
	//camera_set_y_buffer((_y/_gui_scale - global.camera.camera_y)/2, .2);
	
	camera_zoom(50, true, .15);
	draw_set_font(fnt_inventory);
	
	draw_set_color(c_black);
	draw_set_alpha(.2);
	draw_rectangle(_x, _y, _gui_w - _border - 2, _h, false)
	draw_set_alpha(1);
	draw_set_color(c_white);
	
	// Unit Name
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_text_border(_x + _w/2, _y + _padding, _unit.unit.name, c_black);
	
	var _m = matrix_get(matrix_world); // get current matrix  
    var _new_m = matrix_build(0,0,0, 0,0,0, _gui_scale, _gui_scale, 0);
	
	matrix_set(matrix_world, _new_m); 

	// Unit Sprite
	var _section_y = (_y + _padding*2 + string_height(_unit.unit.name))/_gui_scale;
	var _portrait_size = (_w/3)/_gui_scale;
	var _spr = _unit.sprite_index;
	var _char_scale = ((_portrait_size*1.5 - _padding)/sprite_get_height(_spr))/_gui_scale;
	var _spr_w = sprite_get_width(_spr)*_char_scale;
	var _spr_h = sprite_get_height(_spr)*_char_scale;
	
	draw_sprite_stretched(spr_portrait_border, 0, (_x + _padding)/_gui_scale, _section_y, _portrait_size, _portrait_size);
	
	var _sprite_surf = surface_create(_portrait_size - 4, _portrait_size - 4);
	surface_set_target(_sprite_surf);
	
	//draw_sprite_ext(_spr, 0, _padding/_gui_scale + sprite_get_xoffset(_spr)*_char_scale + (_portrait_size - _spr_w*1.25)/2, sprite_get_yoffset(_spr)*_char_scale + (_portrait_size*1.5 - _spr_h)/2, _char_scale, _char_scale, 0, c_white, 1);
	draw_sprite_ext(_spr, 0, (_portrait_size - _spr_w)/2, (_portrait_size - _spr_h*1.5)/2 + sprite_get_yoffset(_spr)*_char_scale, _char_scale, _char_scale, 0, c_white, 1);
	
	// draw player customizables
	if (_unit.unit.is_player) {
		struct_foreach(_unit.unit.sprites, method({_char_scale, _portrait_size, _gui_scale, _spr_w, _spr_h, _spr}, function(_key, _sprite) {
			var _spr_index = spr_clothes_idle;
			var _image = _sprite;
			
			if (is_struct(_sprite)) {
				_spr_index = _sprite.sprite;
				_image = _sprite.image;
			}
			
			draw_sprite_ext(_spr_index, _image, (_portrait_size - _spr_w)/2, (_portrait_size - _spr_h*1.5)/2 + sprite_get_yoffset(_spr)*_char_scale, _char_scale, _char_scale, 0, c_white, 1);
		}));
	}
	
	surface_reset_target();
	draw_surface(_sprite_surf, (_x + _padding)/_gui_scale + 2, _section_y + 2);
	surface_free(_sprite_surf);
	
	// Unit Resources
	if (!struct_exists(_unit.unit, "energy")) return;
	
	var _bar_x = _x/_gui_scale + (_padding*2)/_gui_scale + _portrait_size;
	var _bar_w = _w/_gui_scale - (_padding*3)/_gui_scale - _portrait_size;
	var _bar_h = (_portrait_size - _padding/_gui_scale)/3;
	
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_font(fnt_battle_hud);
	for (var i = 0; i < RESOURCES.LENGTH; ++i) {
		var _resouce = _unit.unit.hp;
		var _max_resource = _unit.unit.stats.hp;
		
		switch(i) {
			case RESOURCES.MANA:
				_resouce = _unit.unit.mana;
				_max_resource = _unit.unit.stats.mana;
				break;
			case RESOURCES.ENERGY:
				_resouce = _unit.unit.energy;
				_max_resource = _unit.unit.stats.energy;
				break;
		}
		
		var _yy = _section_y + _portrait_size - _bar_h - (_bar_h + _padding/2/_gui_scale)*i;
		
		matrix_set(matrix_world, _new_m);
	    draw_sprite_stretched(spr_stat_bar_outline, 0, _bar_x, _yy, _bar_w, _bar_h);
		draw_sprite_stretched_ext(spr_stat_bar, 0, _bar_x, _yy, _bar_w*_resouce/_max_resource, _bar_h, get_resource_color(i), 1);
		
		if (!_unit.unit.is_enemy) {
			matrix_set(matrix_world, _m);
			draw_text_border((_bar_x + _bar_w/2)*_gui_scale, (_yy + _bar_h/2)*_gui_scale, string("{0}/{1}", _resouce, _max_resource), c_black);
		}
	}
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	
	matrix_set(matrix_world, _m);
	
	// Stat Changes
	_section_y += _portrait_size*_gui_scale + _padding*3;
	var _text_offset = 0;
	
	var _stats = struct_get_names(_unit.unit.stat_changes);
	array_sort(_stats, true);
	
	for (var i = 0; i < array_length(_stats); ++i) {
		var _key = _stats[i];
		var _stat = _unit.unit.stat_changes[$ _key];
		
	    if (string_pos(_key, "mana hp energy") > 0) {
			continue;
		}

		draw_text_border(_x + _padding, _section_y + _text_offset, get_stat_display_name(_key) + ": ", c_black);
		
		for (var j = 0; j < 6; ++j) {
			var _col = c_white;
			
			if (6 - j <= abs(_stat) && _stat != 0) {
				_col = (_stat > 0) ? (get_resource_color(RESOURCES.MANA)) : (get_resource_color(RESOURCES.LIFE));
			}
			
		    draw_sprite_ext(spr_stat_change, 0, _x + _w - (sprite_get_width(spr_stat_change) + 10)*j - _padding, _section_y + _text_offset + string_height(_key)/2, 1.2, 1.2, 0, _col, 1);
		}
		
		_text_offset += string_height(_key);
	}
	
	draw_set_halign(fa_left)
	draw_set_valign(fa_bottom)
	for (var i = 0; i < array_length(_unit.unit.passives); ++i) {
	    draw_text(_x + _padding, _gui_h - _padding, string(_unit.unit.passives[i].info.name, ": ", _unit.unit.passives[i].duration))
	}
	
	draw_sprite_stretched(spr_inventory_bg, 0, _x, _y, _w, _h);
	
	draw_set_font(_fnt);
}