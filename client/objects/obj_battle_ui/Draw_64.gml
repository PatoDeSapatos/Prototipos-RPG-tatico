/// @description
if (can_draw) {
	var _gui_scale = display_get_gui_width()/global.camera.camera_w*obj_battle_manager.scale;
	var gui_w = display_get_gui_width()/_gui_scale;
	var gui_h = display_get_gui_height()/_gui_scale;
	var border_y = gui_h div 50;
	var border_x = border_y;
	var portrait_size = gui_w/10;
	var bar_w = gui_w/5;
	var bar_scale = bar_w/sprite_get_width(spr_stat_bar_outline);
	var bar_h = sprite_get_height(spr_stat_bar_outline)*bar_scale;

	var _unit = obj_battle_manager.units[obj_battle_manager.turns];
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_font(fnt_battle_hud);
	
    var _m = matrix_get(matrix_world); // get current matrix
  
    var _new_m = matrix_build(0,0,0, 0,0,0, _gui_scale, _gui_scale, 0);
	
	// Turn User
	for (var i = 0; i < RESOURCES.LENGTH; ++i) {
		var _bar_y = gui_h - border_y - bar_scale*(sprite_get_height(spr_stat_bar_outline)-1)*i - (portrait_size - bar_h*3);
		var _bar_x = border_x + portrait_size;
		
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
		
		matrix_set(matrix_world, _new_m);
		draw_sprite_ext(spr_stat_bar, 0, _bar_x, _bar_y, bar_scale, bar_scale, 0, c_white, .5);
		draw_sprite_ext(spr_stat_bar, 0, _bar_x, _bar_y, bar_scale*((_resouce+sprite_get_xoffset(spr_stat_bar_outline))/(_max_resource+sprite_get_xoffset(spr_stat_bar_outline))), bar_scale, 0, get_resource_color(i), 1);
		draw_sprite_ext(spr_stat_bar_outline, 0, _bar_x, _bar_y, bar_scale, bar_scale, 0, c_white, 1);    
		matrix_set(matrix_world, _m);
	
		draw_set_color(c_white);
		draw_text_border(_bar_x*_gui_scale + (bar_w - sprite_get_xoffset(spr_stat_bar_outline)*bar_scale)*_gui_scale/2, _bar_y*_gui_scale - sprite_get_height(spr_stat_bar_outline)*bar_scale*_gui_scale/2, string("{0}/{1}", _resouce, _max_resource), c_black);
	}
	
	matrix_set(matrix_world, _new_m);
	draw_sprite_stretched(spr_portrait_border, 0, border_x, gui_h - border_y - portrait_size, portrait_size, portrait_size);	
	matrix_set(matrix_world, _m);
	
	// Allies
	gui_w = display_get_gui_width();
	gui_h = display_get_gui_height();
	portrait_size = gui_w/20;
	bar_w = gui_w/15;
	bar_h = (portrait_size - string_height("name"))/3;
	bar_scale = bar_h/sprite_get_height(spr_stat_bar_outline);
	border_y = gui_h div 50;
	border_x = border_y;
	
	var _allies = obj_battle_manager.allies;
	for (var a = 0; a < array_length(_allies); ++a) {
		var _allie = _allies[a];
		
		for (var i = 0; i < RESOURCES.LENGTH; ++i) {
			var _bar_y = border_y + portrait_size - bar_scale*(sprite_get_height(spr_stat_bar_outline)-1)*i;
			var _bar_x = border_x + portrait_size;
		
			var _resouce = _allie.hp;
			var _max_resource = _allie.stats.hp;
		
			switch(i) {
				case RESOURCES.MANA:
					_resouce = _allie.mana;
					_max_resource = _allie.stats.mana;
					break;
				case RESOURCES.ENERGY:
					_resouce = _allie.energy;
					_max_resource = _allie.stats.energy;
					break;
			}
		
			draw_sprite_ext(spr_stat_bar, 0, _bar_x, _bar_y, bar_scale*2, bar_scale, 0, c_white, .5);
			draw_sprite_ext(spr_stat_bar, 0, _bar_x, _bar_y, bar_scale*2*((_resouce+sprite_get_xoffset(spr_stat_bar_outline))/(_max_resource+sprite_get_xoffset(spr_stat_bar_outline))), bar_scale, 0, get_resource_color(i), 1);
		
			draw_sprite_ext(spr_stat_bar_outline, 0, _bar_x, _bar_y, bar_scale*2, bar_scale, 0, c_white, 1);
		}
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
	
		draw_text_border(border_x + portrait_size + 5, border_y, _allie.name, c_black);
		draw_sprite_stretched(spr_portrait_border, 0, border_x, border_y, portrait_size, portrait_size);
		border_y += portrait_size + 8;
	}
	border_y = gui_h div 50;
	
	// Controls
	draw_set_valign(fa_middle);
	
	var _x = gui_w - border_x;
	var _key_size = sprite_get_width(spr_key_button)*2;
	for (var i = 0; i < array_length(controls); ++i) {		
		draw_set_halign(fa_right);
		draw_set_font(fnt_battle_hud);
		var _option_w = string_width(controls[i].name);
		var _key_x = _x - _key_size ;
		
	    draw_text(_x - _key_size - 5, gui_h - border_y - _key_size/2, controls[i].name);
		draw_sprite_stretched(spr_key_button, 0, _key_x, gui_h - border_y - _key_size, _key_size, _key_size);
		
		draw_set_halign(fa_center);
		draw_set_font(fnt_key_button);
		draw_text(_key_x + _key_size/2 + _gui_scale/2, gui_h - border_y - _key_size/2, chr(controls[i].key));
		
		_x -= _option_w + _key_size + 25;
	}
	
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}

if (show_desc) {
	draw_unit_desc(global.camera.follow);	
}
