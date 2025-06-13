/// @description
// Ui
hover_option = noone;
if (can_draw) {
	var _xx = (global.camera.follow.x - sprite_get_xoffset(global.camera.follow.sprite_index)) + sprite_get_width(global.camera.follow.sprite_index)/2;
	var _yy = (global.camera.follow.y - sprite_get_yoffset(global.camera.follow.sprite_index)) + sprite_get_height(global.camera.follow.sprite_index)/2;
	
	var _font = draw_get_font();
	var _depth = gpu_get_depth();
	draw_set_color(c_white);
	draw_set_valign(fa_middle);
	
	draw_set_font(fnt_battle_options);
	
	for (var i = 0; i < array_length(options); ++i) {
		var _option = options[i];
		
		if ((!obj_battle_manager.extra_action || obj_battle_manager.extra_turn_given) && i == array_length(options)-1) {
			_option.able = false
			continue
		}
	
		var _w = (string_width(_option.name)) + sprite_get_width(spr_key_button)*scale/2 + option_border*3;
		var _h = sprite_get_height(spr_key_button)*scale + 10;
		var _option_xscale = _w/sprite_get_width(spr_battle_option);
		var _option_yscale = _h/sprite_get_height(spr_battle_option);
		var _inv = 1;
		
		//var _dir = -(360/(array_length(options)*2)) + _h*i;
		var _dir = _option.angle;
		var _center = _dir == 90 || _dir == 270;
		
		var _currx = _xx + lengthdir_x(distance, _dir) - (_center ? (_w/2 - sprite_get_xoffset(spr_battle_option)*_option_xscale) : 0);
		var _curry = _yy + lengthdir_y(distance, _dir) + (_center ? 5 : 0);
		
		if (_dir > 90 && _dir < 270) {
			_option_xscale *= -1;
			_inv = -1;
		}
		
		_option.able = true;
		if (_option.name == "Move" && obj_battle_manager.movement_actions <= 0) {
			_option.able = false;	
		} else if ((_option.name == "Attack" || _option.name == "Item" || _option.name == "Skills" || _option.name == "Guard") && obj_battle_manager.main_actions <= 0 && !obj_battle_manager.extra_action) {
			_option.able = false;
		}
		
		var _x1 = _currx - sprite_get_xoffset(spr_battle_option)*_option_xscale + 10*_inv;
		var _x2 = _currx - sprite_get_xoffset(spr_battle_option)*_option_xscale + _w*_inv - 10*_inv;
		
		var _selected = point_in_rectangle(
			mouse_x,
			mouse_y,
			_inv > 0 ? _x1 : _x2,
			_curry - sprite_get_yoffset(spr_battle_option)*_option_yscale + 10,
			_inv > 0 ? _x2 : _x1,
			_curry - sprite_get_yoffset(spr_battle_option)*_option_yscale + _h - 10,
		);
		
		var _able = _option.able;
		
		if (_selected && _able) {
			hover_option = options[i];	
		}
		
		var _alpha = _able ? 1 : .7;
		draw_set_alpha(_alpha);
		
		draw_sprite_ext(spr_battle_option, _selected, _currx, _curry, _option_xscale, _option_yscale, 0, c_white, _alpha);
		
		// Key Icon
		draw_sprite_ext(spr_key_button, 0, _currx, _curry, scale, scale, 0, c_white, 1);
		draw_set_font(fnt_key_button);
		draw_set_halign(fa_center);
		draw_text(_currx, _curry, chr(_option.key));
		
		// Name
		draw_set_font(fnt_battle_options);
		draw_set_halign( _inv < 0 ? fa_right : fa_left );
		draw_text(_currx + (sprite_get_width(spr_key_button)/2 + option_border)*_inv, _curry, _option.name);

		draw_set_alpha(1)
	}
	
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(_font);
}