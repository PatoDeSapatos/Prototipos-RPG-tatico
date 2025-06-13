function draw_desc_center(_start_x, _start_y, _text, _width, _sep) {
	var _halign = draw_get_halign();
	var _valign = draw_get_valign();
	
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	
	var _curr_x = _start_x;
	var _curr_y = _start_y - _sep;
	
	var array = string_split(_text, " ");	
	
	for (var i = 0; i < array_length(array); ++i) {
	    var _word = string("{0} ", array[i]);
		var _word_w = string_width(_word);
		
		if (i == 0 || _curr_x + _word_w >= _start_x + _width) {
			_curr_y += _sep;
			
			var _line_w = 0;
			for (var j = i; j < array_length(array); ++j) {
				if (_line_w + string_width(array[j] + " ") > _width) {
					break;	
				}
				
				_line_w += string_width(array[j] + " ");
			}
			_curr_x = _start_x + (_width - _line_w + string_width(" "))/2;
		}
		
		var _col = get_word_highlight(_word);
		draw_text_color(_curr_x, _curr_y, _word, _col, _col, _col, _col, 1);
		_curr_x += _word_w;
	}
	
	draw_set_halign(_halign);
	draw_set_valign(_valign);
}

function highlight_word_filter(_char) {
	return string_pos(_char, "abcdefghijklmnopqrstuvwxyzç1234567890") > 0;
}

function highlight_word_reduce(_prev, _char) {
	return string_concat(_prev, _char);
}

function get_word_highlight(_word, _default=c_white) {
	var _parsed_word = string_lower(string_trim(_word));
	
	var _array = [];
	for (var i = 1; i <= string_length(_parsed_word); ++i) {
	    array_push(_array, string_char_at(_parsed_word, i));
	}
	
	_array = array_filter(_array, highlight_word_filter);
	
	_parsed_word = array_reduce(_array, highlight_word_reduce, "");
	
	if (string_is_real(_parsed_word)) {
		return make_color_rgb(199, 207, 204);
	}	
	
	switch(_parsed_word) {
		case "poison":
			return get_type_color(MOVE_TYPES.POISON);
		case "damage":
			return get_type_color(MOVE_TYPES.SLASHING);
		case "heal": case "heals": case "health": case "hp":
			return make_color_rgb(117, 167, 67);
		case "raises": case "raise":
			return make_color_rgb(79, 143, 186);
		default:
			return _default;
	}
}

function draw_text_border(_x, _y, _text, _border_color) {
	var _text_col = draw_get_color();
	
	draw_set_color(_border_color);
	draw_text(_x + 2, _y, _text);
	draw_text(_x - 2, _y, _text);
	draw_text(_x, _y + 2, _text);
	draw_text(_x, _y - 2, _text);
	
	draw_set_color(_text_col);
	draw_text(_x, _y, _text);
}

function draw_desc_box(_x, _y, _text, _pointing_right=false) {	
	var _border = 15;
	
	var _valign = draw_get_valign();
	var _halign = draw_get_halign();
	var _fnt = draw_get_font();
	
	draw_set_font(fnt_desc_box);
	draw_set_valign(fa_middle);
	draw_set_halign(fa_right);
	
	var _xscale = (string_width(_text)+_border)/sprite_get_width(spr_desc_box);
	var _yscale = (string_height(_text)+_border)/sprite_get_height(spr_desc_box);
	
	var _gui_scale = 2;
	
	var _m = matrix_get(matrix_world); // get current matrix  
    var _new_m = matrix_build(0,0,0, 0,0,0, _gui_scale, _gui_scale, 0);
	
	matrix_set(matrix_world, _new_m); 
	
	draw_sprite_ext(spr_desc_box, 0, _x/_gui_scale, _y/_gui_scale, _xscale, _yscale, 0, c_white, 1);
	draw_text_border((_x - 2.5*_xscale - _border/2)/_gui_scale, _y/_gui_scale, _text, c_black);
	
	matrix_set(matrix_world, _m); 
	
	draw_set_valign(_valign);
	draw_set_halign(_halign);
	draw_set_font(_fnt);
}