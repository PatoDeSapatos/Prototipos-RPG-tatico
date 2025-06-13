function inventory_draw_items() {
	// Items List
	draw_items(inventory, false);

	if (is_struct( active_item ) && is_struct(bag_item_options)) {
		if ( focus == FOCUS.ITEM ) {
			var _item_info = get_item_by_id( active_item.id );
			var _item_options = noone;
			var _selected_option = -1;
	
			if ( is_instanceof(_item_info, Material_Item) ) {
				_item_options = bag_item_options.material;
			} else if ( is_instanceof(_item_info, Equipment_Item) ) {
				_item_options = bag_item_options.equipment;
			} else if ( is_instanceof(_item_info, Consumable_Item) ) {
				_item_options = bag_item_options.consumable; 
			}
	
			_selected_option = draw_item_options(_item_options.options);
			_item_options.action.take_action(_selected_option);
		}
	}

	if(has_tabs) {
		var _changed_category = selected_category;
		selected_category += right_input - left_input;
		selected_category = clamp(selected_category, 0, ItemCategory.LENGTH - 1);
		if ( _changed_category != selected_category ) {
			selected_item = 0;	
		}
	}
}

function draw_item_options(_options) {
	box_delay++;
	if (box_delay < 10) {
		item_option_selected = 0;
		return undefined;
	}

	var _options_h = string_height(_options[0]) + 10;
	var _options_w = 0;
	for (var i = 0; i < array_length(_options); ++i) {
	    _options_w = max(_options_w, string_width(_options[i]));
	}
	_options_w += 10;
	
	var _mouse_hover = false;
	var _current_y = active_item_y + items_box_name_h;
	draw_set_halign(fa_center);
	draw_set_valign(fa_center);
	for (var i = 0; i < array_length(_options); ++i) {
		var _x = item_option_x;
		
		draw_sprite_stretched(spr_item_options_bg, 0, _x - _options_w/2, _current_y -_options_h/2, _options_w, _options_h);
		draw_set_color(item_option_selected == i ? (c_ltgray) : (c_white));
	    draw_text(_x, _current_y, _options[i]);
		if (mouse_navigation) { 
			if (point_in_rectangle(mouse_gui_x, mouse_gui_y, _x - _options_w/2, _current_y - _options_h/2, _x + _options_w/2, _current_y + _options_h/2)) {
				item_option_selected = i;
				_mouse_hover = true;
				if (mouse_l) {
					return item_option_selected;
				}
			}
		} else if ( confirm_input ) {
			return item_option_selected;
		}

		_current_y += _options_h;
	}
	mouse_hover_option = _mouse_hover;
	
	item_option_selected += down_input - up_input;
	item_option_selected = clamp(item_option_selected, 0, array_length(_options) - 1)
	if (cancel_input) focus = FOCUS.LIST;
}

function show_discard_panel(_item) {
	focus = FOCUS.ITEM_PANEL;
	var _parameters = {
		item_id: _item.id,
		quantity: discard_panel.quantity
	}
	
	discard_panel.update(_item, _parameters)
	active_panel = discard_panel;
}

function show_crafting_panel(_recipe) {
	focus = FOCUS.ITEM_PANEL;
	var _parameters = {
		recipe: _recipe	
	}
	
	craft_item_panel.update(_recipe, _parameters);
	active_panel = craft_item_panel;
}