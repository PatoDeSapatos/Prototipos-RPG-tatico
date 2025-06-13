function inventory_draw_skills() {
	if ( !surface_exists(items_box_list_surf) ) {
		items_box_list_surf = surface_create(items_box_w, items_box_h);	
	}
	surface_set_target(items_box_list_surf);
	draw_clear_alpha(c_black, 0);
	
	var _fnt = draw_get_font();
	draw_set_font(fnt_inventory)
	draw_set_valign(fa_middle);
	
	selected_item = clamp(selected_item + (down_input - up_input), 0, array_length(skills)-1);
	
	selector_y = noone;
	mouse_hover_option = false;
	var _current_y = items_box_name_offset;
	var _prev_selected_item = selected_item;
	for (var i = 0; i < array_length(skills); ++i) {
		var _y = _current_y + items_box_name_h/2 + items_box_border/2;
		var _item = skills[i];
	
		var _mouse_hover = mouse_navigation && point_in_rectangle(mouse_gui_x, mouse_gui_y, items_box_x, items_box_name_y + _y - items_box_name_h/2, items_box_x + items_box_w, items_box_name_y + _y + items_box_name_h/2);
	
		if (_mouse_hover) {
			mouse_hover_option = true;
			selected_item = i;
		}
	
		var _col = get_type_color(skills[i].types[0]);
		var _alpha = selected_item == i ? 1 : .7;
	
		if ( selected_item == i ) {
			selector_y = _y;
		}
		
		draw_set_alpha(_alpha);
		draw_set_color(_col);
		draw_rectangle(0, _y - items_box_name_h/2 - items_box_border/4 + 1, items_box_w, _y + items_box_name_h/2 + items_box_border/4 - 1, false);
		draw_set_color(c_white);
		draw_set_alpha(1);
	
		if (skills[i] == active_item) {
			active_item_y = _y + items_box_name_y - items_box_name_h/2;	
		}
	
		// Item Image
		var _type = (struct_exists(_item, "types")) ? (_item.types[0]) : (0);
		var _icon_scale = global.res_scale * 2;
		var _icon_w = sprite_get_width(spr_move_type_icons)*_icon_scale;
		var _icon_h = sprite_get_height(spr_move_type_icons)*_icon_scale;
		
		draw_sprite_ext( spr_move_type_icons, _type, items_box_name_x - items_box_spr_size, _y, _icon_scale, _icon_scale, 0, c_white, 1 );
		if (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), items_box_name_x - items_box_spr_size - _icon_w/2, _y - _icon_h/2, items_box_name_x - items_box_spr_size + _icon_w/2, _y + _icon_h/2)) {
			draw_desc_box(items_box_w - _string_w - (items_box_name_h - _string_h) - 10, _y, "");	
		}
	
		// Item Name
		draw_set_color(c_white);
		draw_set_halign(fa_left);
		draw_text_color(items_box_name_x - 2, _y, _item.name, c_black, c_black, c_black, c_black, 1);
		draw_text_color(items_box_name_x + 2, _y, _item.name, c_black, c_black, c_black, c_black, 1);
		draw_text_color(items_box_name_x, _y - 2, _item.name, c_black, c_black, c_black, c_black, 1);
		draw_text_color(items_box_name_x, _y + 2, _item.name, c_black, c_black, c_black, c_black, 1);
		draw_text(items_box_name_x, _y, _item.name);
	
		// Item Cost
		var _string = string("{0}{1}", _item.costValue, get_resource_name(_item.resource));
		var _string_w = items_box_w/5;
		var _string_h = string_height(_string)/1.5;
		_col = get_resource_color(_item.resource);
		
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		
		draw_roundrect_color(items_box_w - _string_w - (items_box_name_h - _string_h), _y - _string_h, items_box_w - (items_box_name_h - _string_h), _y + _string_h, c_black, c_black, false);
		draw_text_color(items_box_w - _string_w/2 - (items_box_name_h - _string_h), _y, _string, _col, _col, _col, _col, 1);
		
		if (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), items_box_x + items_box_w - _string_w - (items_box_name_h - _string_h), items_box_name_y + _y - _string_h, items_box_x + items_box_w - (items_box_name_h - _string_h),items_box_name_y + _y + _string_h)) {
			draw_desc_box(items_box_w - _string_w - (items_box_name_h - _string_h) - 10, _y, "Skill Cost");
		}

		//draw_set_halign(fa_right);
		
		//draw_text_color(items_box_w - (items_box_name_h - _string_h), _y, get_resource_name(_item.resource), _col, _col, _col, _col, 1);
		
		//draw_sprite_ext( spr_move_category_icons, _item.moveCategory, items_box_category_x, _y, global.res_scale * 2, global.res_scale * 2, 0, c_white, 1 );
	
		_current_y += items_box_name_h + items_box_border/2;
	}
	
	surface_reset_target();
	draw_surface(items_box_list_surf, items_box_x, items_box_name_y);
	
	// Skill desc
	if (!is_struct(skills[selected_item])) return;
	
	var _item = skills[selected_item];
	
	draw_set_color(c_black);
	draw_set_alpha(.8);
	draw_rectangle(equipment_box_x, equipment_box_y, equipment_box_x + equipment_box_w, equipment_box_y + equipment_box_h, false);
	draw_set_color(c_white);
	draw_set_alpha(1);
	draw_sprite_stretched(spr_inventory_bg, 0, equipment_box_x, equipment_box_y, equipment_box_w + global.res_scale, equipment_box_h);
	
	// Move name
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	var _col = get_type_color(_item.types[0]);
	draw_text_color(equipment_box_x + equipment_box_w/2, equipment_box_y + equipment_box_border, _item.name, _col, _col, _col, _col, 1);
	
	// Move description
	draw_set_valign(fa_top);
	draw_set_halign(fa_center);
	var _desc = _item.description;
	var _start_x = equipment_box_x;
	var _start_y = equipment_box_y + equipment_box_border + string_height(_item.name);
		
	draw_desc_center(_start_x, _start_y, _desc, equipment_box_w, string_height(_desc));
	
	draw_set_halign(fa_left);
	draw_set_valign(fa_bottom);
	
	// Move Types
	draw_text(equipment_box_x + equipment_box_border, equipment_box_y + equipment_box_h - equipment_box_border, "Types: ");
	for (var i = 0; i < array_length(_item.types); ++i) {
	    var _xx = equipment_box_x + equipment_box_border + string_width("Types:  ") + sprite_get_width(spr_move_type_icons)/2 + (sprite_get_width(spr_move_type_icons) * global.res_scale*2)*i;
		var _yy = equipment_box_y + equipment_box_h - equipment_box_border - sprite_get_height(spr_move_type_icons)*global.res_scale/1.5;
		draw_sprite_ext(spr_move_type_icons, _item.types[i], _xx, _yy, global.res_scale * 2, global.res_scale * 2, 0, c_white, 1);
	}
	
	// Move Category
	draw_sprite_ext(
		spr_move_category_icons,
		_item.moveCategory,
		equipment_box_x + equipment_box_w - equipment_box_border - sprite_get_width(spr_move_category_icons)*global.res_scale,
		equipment_box_y + equipment_box_h - equipment_box_border - sprite_get_height(spr_move_category_icons)*global.res_scale/1.5,
		global.res_scale*2, 
		global.res_scale*2, 
		0,
		c_white,
		1
	);
	
	draw_set_font(_fnt);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}