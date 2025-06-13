function add_battle_text(_text) {
	var _array = string_split(_text, " ");
	
	array_map_ext(_array, function (_value) {
		return {
			string: _value,
		}
	});
	
	if (!instance_exists(obj_battle_text)) {
		instance_create_depth(0, 0, -1000, obj_battle_text);	
	}
	
	with(obj_battle_text) {
		var _prev_fnt = draw_get_font();
		
		draw_set_font(fnt_battle_text);
		var _width = string_width(_text);
		var _height = string_height(_text);
		draw_set_font(_prev_fnt);
		
		if (array_length(texts) <= 0) {
			curr_x = gui_w + _width + padding;
		} else {
			page++;	
		}
		
		array_push(texts, _array);
		array_push(text_width, _width);
		array_push(text_height, _height);
		
		vanish = false;
		timer = 0;
	}
}

function battle_text_set_color(_color, _firts_word, _last_word) {
	if (instance_exists(obj_battle_text)) {
		with(obj_battle_text) {
			var _text = texts[array_length(texts)-1];
			
			for (var i = _firts_word; i <= _last_word; ++i) {
			    _text[i].col = _color;
			}
		}
	}
}