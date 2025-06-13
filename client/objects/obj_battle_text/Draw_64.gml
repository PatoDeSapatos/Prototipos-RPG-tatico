/// @description
var _prev_fnt = draw_get_font();

draw_set_font(fnt_battle_text);

// Background Shadow
draw_set_color(c_white);
draw_rectangle(
	curr_x,
	start_y,
	curr_x + text_width[page] + padding*1.5,
	start_y + text_height[page] + padding*1.5,
	false
);

// Background
draw_set_color(col);
draw_rectangle(
	curr_x - padding,
	start_y - padding,
	curr_x + text_width[page] + padding,
	start_y + text_height[page] + padding,
	false
);
draw_set_color(c_white);

// Text
var _length = 0;
for (var i = 0; i < array_length(texts[page]); ++i) {
    var _text = texts[page, i];
	var _col = (struct_exists(_text, "col")) ? (_text.col) : (c_white);
	
	draw_text_color(curr_x + _length, start_y, _text.string, _col, _col, _col, _col, 1);
	_length += string_width(string("{0} ", _text.string));
}

draw_set_font(_prev_fnt);
