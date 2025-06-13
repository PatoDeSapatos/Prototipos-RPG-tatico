/// @description
if ( !inventory_open ) return;
var _prev_item = selected_item;

draw_set_color(c_black);
draw_set_alpha(.7);
draw_rectangle(0, 0, gui_w, gui_h, false);
draw_set_color(c_white);
draw_set_alpha(1);

// Inventory Tabs
if (has_tabs) {
	var _tab_w = sprite_get_width(spr_inventory_tabs) * global.res_scale*2;
	var _tab_h = sprite_get_height(spr_inventory_tabs) * global.res_scale*2;

	for (var i = sprite_get_number(spr_inventory_tabs) - 1; i >= 0; --i) {
		if ( i == selected_tab ) continue;
		draw_sprite_ext(spr_inventory_tabs, i, tabs_x, tabs_y[i], global.res_scale*2, global.res_scale*2, 0, c_white, 1);
	
		if ( (focus == FOCUS.LIST || focus == FOCUS.ITEM) && mouse_l && point_in_rectangle(mouse_gui_x, mouse_gui_y, tabs_x, tabs_y[i] + global.res_scale*6, tabs_x + _tab_w, tabs_y[i] + _tab_h - global.res_scale*3) ) {
			focus = FOCUS.LIST;
			items_box_name_offset = 0;
			selected_tab = i;
		}	
	}
}

draw_set_color(c_black);
draw_set_alpha(.8);
draw_rectangle( 
	items_box_x,
	items_box_y,
	items_box_x + items_box_w,
	items_box_y + items_box_h,
	false
);
draw_set_alpha(1);
draw_set_color(c_white);

switch ( selected_tab ) {
	case TABS.ITEMS:
		inventory_draw_items();
		break;
	case TABS.CRAFTING:
		inventory_draw_recipes();
		break;
	case TABS.SKILLS:
		inventory_draw_skills();
		break;
}

draw_sprite_stretched(spr_inventory_bg, 0, items_box_x, items_box_y, items_box_w + global.res_scale, items_box_h);
if ( selected_tab == TABS.CRAFTING ) draw_sprite_stretched(spr_inventory_bg, 0, items_box_x - global.res_scale, ingredients_box_y - ingredients_border, items_box_w + global.res_scale, ingredients_box_h + ingredients_border);

if (has_tabs) {
	// Selected Tab
	draw_sprite_ext(spr_inventory_tabs, selected_tab, tabs_x, tabs_y[selected_tab], global.res_scale*2, global.res_scale*2, 0, c_ltgray, 1);
}

// Panels
if ( focus == FOCUS.ITEM_PANEL ) {
	draw_item_quantity_panel();
}
	
if ( focus == FOCUS.ORDER ) {
	draw_order_box();
}

if ( _prev_item != selected_item ) {
	get_recipe_ingredients();
}

// Equipment Box
if (has_equipment_box) {
	draw_set_color(c_white);
	draw_rectangle(equipment_box_x, equipment_box_y, equipment_box_x2, equipment_box_y2, false);
	draw_set_color(c_black);
	draw_line_width(equipment_box_x - global.res_scale, stats_box_y - equipment_box_border, equipment_box_x2, stats_box_y - equipment_box_border, 2);
	draw_sprite_stretched(spr_inventory_bg, 0, equipment_box_x, equipment_box_y, equipment_box_x2 - equipment_box_x, equipment_box_y2 - equipment_box_y);

	var _current_x = equipment_box_x + equipment_box_border;
	var _current_y = equipment_box_y + equipment_box_border;
	var _names = struct_get_names(equipments);
	var _rows = equipment_rows;
	draw_set_halign(fa_left);
	draw_set_valign(fa_middle);

	for (var i = 0; i < struct_names_count(equipments); ++i) {
		var _key = _names[i];
		var _value = struct_get(equipments, _key);
	
		var _string = _key + ": ";
		var _string_width = string_width(_string);
		var _string_height = string_height(_string);
		var _spr = -1;
	
		if (i > 0 && i % _rows == 0) {
			_current_x += equipment_slot_w + equipment_box_border;
			_current_y = equipment_box_y + equipment_box_border;
		}
	
		draw_text(_current_x, _current_y + equipment_slot_h/2, _string);
	
		if (_value != noone) {
			if (_value == -1) {
				_value = struct_get(equipments, Hand1Slot);
				draw_set_alpha(.7);
			}
		
			draw_set_color(c_black);
			var _item = get_item_by_id(_value.id);
			draw_sprite_stretched(spr_items, _item.sprId, _current_x + _string_width, _current_y + equipment_slot_h/4, _string_height, _string_height);
			draw_text(_current_x + _string_width + _string_height, _current_y + equipment_slot_h/2, " " + _item.display_name);
			draw_set_alpha(1);
		}
	
		_current_y += equipment_slot_h;
	}

	_current_x = equipment_box_x + equipment_box_border;
	_current_y = stats_box_y;
	_names = struct_get_names(player_equipment_stats);
	_rows = stats_rows;
	var _active_item_exists = false;
	var _comparing_names = noone;
	var _stats = noone;

	if ( is_struct(active_item) && focus == FOCUS.ITEM ) {
		if (is_instanceof(active_item, Equipment_Stack)) {
			_stats = active_item.stats;
			_comparing_names = struct_get_names(_stats);	
			_active_item_exists = true;
		} else if (is_instanceof(active_item, Recipe_Stack)) {
			var _recipe = get_recipe_by_id(active_item.id);
			_result = get_item_by_id(_recipe.result_id);
		
			_stats = _result.stats;
			_comparing_names = struct_get_names(_stats);
			_active_item_exists = true;
		}
	}

	for (var i = 0; i < struct_names_count(player_equipment_stats); ++i) {
		var _key = _names[i];
		var _value = struct_get(player_equipment_stats, _key);
		var _string = _key + ": " + string(struct_get(player_base_stats, _key) + _value);
		var _string_width = string_width(_string);
	
		if (i > 0 && i % _rows == 0) {
			_current_x += stats_w;
			_current_y = stats_box_y;
		}
	
		draw_set_color(c_black);
	    draw_text(_current_x, _current_y + stats_h/2, _string);
		if ( _active_item_exists ) {
			var _comparing_stats = (struct_get(player_base_stats, _comparing_names[i]) ) + struct_get(_stats, _comparing_names[i]);
		
			if (_comparing_stats != _value + struct_get(player_base_stats, _comparing_names[i])) {
				draw_set_color(_comparing_stats > _value ? (c_green) : (c_red));
				draw_text(_current_x + _string_width, _current_y + stats_h/2, " -> " + string(_comparing_stats));
			}
		}
	
		_current_y += stats_h;
	}
}
draw_set_color(c_white);

// Skil Selector
if (selector_y != noone) {
	draw_sprite_ext(spr_skill_selector, selector_image, items_box_x, items_box_name_y + selector_y, global.res_scale*2, global.res_scale*2, 0, c_white, 1);
	selector_image += sprite_get_speed(spr_skill_selector)/FRAME_RATE;
	if (selector_image > sprite_get_number(spr_skill_selector)) {
		selector_image = 0;	
	}
}