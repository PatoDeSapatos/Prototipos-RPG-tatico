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
				reading_string = string_concat(reading_string, "|");	
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
				menu_change_page(0);
				return;
			} else if ( option_selected == array_length(options[page])-1 ) {
				menu_change_page(0);
				return;
			}
		}	
}

function place_holder(_string) {
	
}