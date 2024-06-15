enum MAIN_MENU_PAGES {
	PRINCIPAL,
	ENTER_DUNGEON,
	CREATE_DUNGEON,
	ACCOUNT,
	OPTIONS,
	REGISTER_USERNAME,
	REGISTER_PASSWORD,
	LOGIN_USERNAME,
	LOGIN_PASSWORD,
	PRIVATE_DUNGEON,
	PUBLIC_DUNGEON,
	REGISTER_LOGIN
}

function menu_get_option_selected() {
	var _options_length = array_length(options[page])
	
	if ( input_down ) {
		option_selected = ++option_selected % _options_length;
	} else if ( input_up ) {
		option_selected = (--option_selected + _options_length) % _options_length;
	}
}

function draw_text_input_page(_callback) {
			if (setup) {
			keyboard_string = "";
			reading_string = "";
			max_string_length = 20;
			setup = false;
		}
	
		if ( option_selected == 1 ) {
			reading_string = keyboard_string;
			if ( string_length(reading_string) > max_string_length ) {
				var _string = string_copy(reading_string, 0, max_string_length);
				reading_string = _string;
				keyboard_string = _string;
			}
			if ( string_char_at(reading_string, string_length(reading_string)-1) != "|" ) {
				reading_string = reading_string + "|";	
			}
		} else {
			keyboard_string = reading_string;
			if ( string_char_at(reading_string, string_length(reading_string)) == "|" ) {
				reading_string = string_copy(reading_string, 0, string_length(reading_string) - 1);	
			}
		}
		
		options[page, 1] = reading_string;
	
		if ( input_forward ) {
			if ( option_selected == 0 ) {
				option_selected = 1;
			} else if (option_selected == 2) {
				_callback(reading_string);
				return;
			} else if ( option_selected == array_length(options[page])-1 ) {
				menu_change_page(0);
				return;
			}
		}	
}

function create_error_message(_message) {
	with (instance_create_layer(0, 0, "Instances", obj_error_message)) {
		error_message = _message;
	}
}

function create_menu_button(_x, _y, _width, _height, _text, _color, _hover_color, _font_color, _font_color_hover, _callback, _font=-1) {
	var _button = instance_create_layer(_x, _y, "Instances", obj_menu_button);
	var _depth = depth;
	
	with (_button) {
		button_width = _width;
		button_height = _height;
		button_text = _text;
		button_color = _color;
		button_font = _font;
		hover_color = _hover_color;
		button_font_color = _font_color;
		button_font_color_hover = _font_color_hover;
		callback = _callback;
		depth = _depth - 1;
	}
	
	return _button;
}

function place_holder(_string) {
	
}