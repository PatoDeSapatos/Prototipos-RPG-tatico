/// @description Insert description here
if ( global.loading ) return;

draw_set_color(c_white);
var _width = room_width;
var _height = room_height;
var _bar_width = 500;
var _bar_height = 50;

if ( !setup ) {
	init_y = _height/2;
	
	for (var i = 0; i < array_length(options); ++i) {
	    text_height[i] = string_height( options[i][0] );
		option_height[i] = text_height[i] + offset + _bar_height;
		init_y -= option_height[i];
	}

	setup = true;
}

// Draw Options
var _current_y = init_y;
var _hover = false;
for (var i = 0; i < array_length(options); ++i) {
	var _x1 = (_width - _bar_width)/2;
	var _y1 = _bar_height/2 + _current_y + text_height[i] + offset/2;
	var _x2 = (_width + _bar_width)/2;
	var _y2 = _bar_height + _current_y + text_height[i] + offset/2;
	
	// Check Selected Option
	if ( point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x2, _y2) ) {
		_hover = true;
		option_hover = i;
	} else if (!_hover) {
		option_hover = -1;
	}
	
	draw_text( 
		_x1,
		(_bar_height)/2 + _current_y,	
		options[i][0]
	);
	
	// Draw Option Background
	if ( option_selected == i ) draw_set_color(c_yellow);
	else if ( option_hover == i ) draw_set_color(c_red);
	draw_rectangle( _x1, _y1, _x2, _y2, true );
	draw_set_color(c_white);
	
	// Draw Player Inputs
	draw_text(_x1 + offset/2, _y1, options[i, 1]);
	
	_current_y += option_height[i];
}

// Submit Button
var _x1 = (_width - _bar_width)/2;
var _y1 = _current_y + offset;
var _x2 = (_width + _bar_width)/2;
var _y2 = _current_y + offset + _bar_height/2;
var _button_hover = point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x2, _y2);

draw_rectangle(_x1, _y1, _x2, _y2, !_button_hover);

draw_set_halign(fa_center);
if ( _button_hover ) {
	draw_set_color(c_black);
	if ( mouse_check_button_pressed(mb_left) ) {
		global.playerId = options[0, 1];
		global.battleId = options[1, 1];
		request_player_exists();
	}
}

draw_text(_x1 + (_x2 - _x1)/2, _y1, "Enviar")

draw_set_halign(fa_left)
draw_set_color(c_white);

// Change Selected Option
if ( mouse_check_button_pressed(mb_left) ) {
	option_selected = option_hover;
}

// Get player input
if ( keyboard_check_pressed( vk_tab ) ) {
	option_selected++;
	if ( option_selected >= array_length(options) ) option_selected = 0;
} else if ( option_selected != -1 ) {
	if (keyboard_check_pressed(vk_anykey) && keyboard_lastchar != undefined) {
		options[option_selected, 1] += keyboard_lastchar;
	}
	if ( keyboard_check_pressed(vk_backspace) ) {
		options[option_selected, 1] = string_delete(options[option_selected, 1], string_length(options[option_selected, 1])-1, 2);
	}
}